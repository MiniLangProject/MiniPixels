// SPDX-License-Identifier: Apache-2.0
// Optional Win32 OpenGL scene backend. The game and scene traversal stay in MiniLang.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <GL/gl.h>
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <unordered_map>
#include <vector>
#define API extern "C" __declspec(dllexport)
using GenFn = void (APIENTRY*)(GLsizei, GLuint*);
using BindFn = void (APIENTRY*)(GLenum, GLuint);
using AttachFn = void (APIENTRY*)(GLenum, GLenum, GLenum, GLuint, GLint);
using StatusFn = GLenum (APIENTRY*)(GLenum);
using DeleteFn = void (APIENTRY*)(GLsizei, const GLuint*);
using SwapFn = BOOL (WINAPI*)(int);
using GetSwapFn = int (WINAPI*)();
static GenFn genFbo; static BindFn bindFbo; static AttachFn attachFbo;
static StatusFn statusFbo; static DeleteFn deleteFbo;
static SwapFn swapInterval; static GetSwapFn getSwapInterval;
static HGLRC owner = nullptr;
static GLuint fbo=0, scene=0, white=0, light=0;
static int width=0,height=0; static bool ready=false,drawing=false;
static const GLenum FBO=0x8D40, ATTACHMENT=0x8CE0;
struct Texture { GLuint id; int w,h; bool opaque; };
static std::unordered_map<const void*, Texture> textures;
struct Vertex { float x,y,u,v; uint32_t color; };
static std::vector<Vertex> vertices;
static GLuint batchTexture=0;
static uint64_t uploadBytes=0, drawCalls=0;
static void destroyLight();
static bool current() { return ready && owner && wglGetCurrentContext()==owner; }
static PROC proc(const char* name) {
    PROC p=wglGetProcAddress(name);
    if (!p || p==(PROC)1 || p==(PROC)2 || p==(PROC)3 || p==(PROC)-1) return nullptr;
    return p;
}
static void flush() {
    if(vertices.empty()) return;
    glBindTexture(GL_TEXTURE_2D,batchTexture);
    glEnableClientState(GL_VERTEX_ARRAY); glEnableClientState(GL_TEXTURE_COORD_ARRAY); glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2,GL_FLOAT,sizeof(Vertex),&vertices[0].x);
    glTexCoordPointer(2,GL_FLOAT,sizeof(Vertex),&vertices[0].u);
    glColorPointer(4,GL_UNSIGNED_BYTE,sizeof(Vertex),&vertices[0].color);
    glDrawArrays(GL_QUADS,0,(GLsizei)vertices.size());
    glDisableClientState(GL_VERTEX_ARRAY); glDisableClientState(GL_TEXTURE_COORD_ARRAY); glDisableClientState(GL_COLOR_ARRAY);
    vertices.clear(); ++drawCalls;
}
static void quad(GLuint tex,float x,float y,float w,float h,float u0,float v0,float u1,float v1,uint32_t color) {
    // MiniPixels packs numeric 0xRRGGBBAA; GL consumes in-memory RGBA bytes.
    color=((color>>24)&255)|((color>>8)&0xff00)|((color<<8)&0xff0000)|(color<<24);
    if(tex!=batchTexture || vertices.size()>=16384) flush();
    batchTexture=tex;
    vertices.push_back({x,y,u0,v0,color}); vertices.push_back({x+w,y,u1,v0,color});
    vertices.push_back({x+w,y+h,u1,v1,color}); vertices.push_back({x,y+h,u0,v1,color});
}
static GLuint makeTexture(int w,int h,const void* data,bool opaque=false) {
    GLuint id=0; glGenTextures(1,&id); glBindTexture(GL_TEXTURE_2D,id);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,0x812F);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,0x812F);
    glPixelStorei(GL_UNPACK_ALIGNMENT,4);
    glTexImage2D(GL_TEXTURE_2D,0,opaque?GL_RGB8:GL_RGBA8,w,h,0,GL_RGBA,GL_UNSIGNED_BYTE,data);
    return id;
}
static void ortho(int w,int h) {
    glMatrixMode(GL_PROJECTION); glLoadIdentity(); glOrtho(0,w,h,0,-1,1);
    glMatrixMode(GL_MODELVIEW); glLoadIdentity();
}
API int mpGpuSwap(int interval) {
    if(!wglGetCurrentContext()) return -2;
    swapInterval=(SwapFn)proc("wglSwapIntervalEXT"); getSwapInterval=(GetSwapFn)proc("wglGetSwapIntervalEXT");
    if(!swapInterval || !getSwapInterval) return -1;
    if(interval>=0 && !swapInterval(interval?1:0)) return -2;
    return getSwapInterval();
}
API void mpGpuInfo() {
    const char* vendor=(const char*)glGetString(GL_VENDOR);
    const char* renderer=(const char*)glGetString(GL_RENDERER);
    const char* version=(const char*)glGetString(GL_VERSION);
    printf("GPU vendor=%s renderer=%s version=%s swap_interval=%d\n",vendor?vendor:"unknown",renderer?renderer:"unknown",version?version:"unknown",mpGpuSwap(-1)); fflush(stdout);
}
API int mpGpuInit(int w,int h) {
    if(ready || !wglGetCurrentContext() || w<1 || h<1) return 0;
    genFbo=(GenFn)proc("glGenFramebuffers"); bindFbo=(BindFn)proc("glBindFramebuffer");
    attachFbo=(AttachFn)proc("glFramebufferTexture2D"); statusFbo=(StatusFn)proc("glCheckFramebufferStatus");
    deleteFbo=(DeleteFn)proc("glDeleteFramebuffers");
    if(!genFbo || !bindFbo || !attachFbo || !statusFbo || !deleteFbo) return 0;
    GLint limit=0; glGetIntegerv(GL_MAX_TEXTURE_SIZE,&limit); if(w>limit || h>limit) return 0;
    owner=wglGetCurrentContext(); width=w; height=h;
    scene=makeTexture(w,h,nullptr); genFbo(1,&fbo); bindFbo(FBO,fbo);
    attachFbo(FBO,ATTACHMENT,GL_TEXTURE_2D,scene,0);
    bool complete=statusFbo(FBO)==0x8CD5;
    bindFbo(FBO,0);
    if(!complete) { deleteFbo(1,&fbo); glDeleteTextures(1,&scene); fbo=scene=0; return 0; }
    bindFbo(FBO,fbo); glViewport(0,0,w,h); glClearColor(0,0,0,1); glClear(GL_COLOR_BUFFER_BIT); bindFbo(FBO,0);
    uint32_t rgba=0xffffffff; white=makeTexture(1,1,&rgba);
    vertices.reserve(16384); ready=true; return 1;
}
API int mpGpuResize(int w,int h) {
    if(!current() || drawing || w<1 || h<1) return 0;
    if(w==width && h==height) return 1;
    GLint limit=0; glGetIntegerv(GL_MAX_TEXTURE_SIZE,&limit); if(w>limit || h>limit) return 0;
    flush();
    GLuint nextScene=makeTexture(w,h,nullptr),nextFbo=0; genFbo(1,&nextFbo); bindFbo(FBO,nextFbo);
    attachFbo(FBO,ATTACHMENT,GL_TEXTURE_2D,nextScene,0);
    if(statusFbo(FBO)!=0x8CD5) {
        bindFbo(FBO,0); deleteFbo(1,&nextFbo); glDeleteTextures(1,&nextScene); return 0;
    }
    glViewport(0,0,w,h); glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_TRUE);
    glClearColor(0,0,0,1); glClear(GL_COLOR_BUFFER_BIT); glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_FALSE); bindFbo(FBO,0);
    deleteFbo(1,&fbo); glDeleteTextures(1,&scene); if(light) glDeleteTextures(1,&light);
    fbo=nextFbo; scene=nextScene; light=0; width=w; height=h; drawing=false; return 1;
}
API void mpGpuResetTextures() {
    if(!current()) return;
    flush(); for(auto &entry:textures) glDeleteTextures(1,&entry.second.id);
    textures.clear(); batchTexture=0;
}
API void mpGpuShutdown() {
    if(!current()) return;
    flush(); mpGpuResetTextures(); deleteFbo(1,&fbo); glDeleteTextures(1,&scene); glDeleteTextures(1,&white);
    if(light) glDeleteTextures(1,&light);
    destroyLight();
    fbo=scene=white=light=0; ready=false; drawing=false; owner=nullptr;
}
// Positive means a new resident texture: MiniLang retains its source image until reset.
// Negative means a cache hit. Source pointer is a key, never dereferenced after this call.
API int mpGpuTexture(const void* pixels,int w,int h,bool opaque) {
    if(!current() || !pixels || w<1 || h<1) return 0;
    auto i=textures.find(pixels); if(i!=textures.end()) return -(int)i->second.id;
    flush(); GLint limit=0; glGetIntegerv(GL_MAX_TEXTURE_SIZE,&limit);
    if(w>limit || h>limit) return 0;
    GLuint id=makeTexture(w,h,pixels,opaque); textures[pixels]={id,w,h,opaque}; uploadBytes+=(uint64_t)w*h*4;
    return (int)id;
}
API void mpGpuUpdate(const void* pixels,int w,int h,bool opaque) {
    if(!current() || !pixels || w<1 || h<1) return;
    auto i=textures.find(pixels); if(i==textures.end()) return;
    flush(); glBindTexture(GL_TEXTURE_2D,i->second.id);
    if(i->second.w!=w || i->second.h!=h || i->second.opaque!=opaque) {
        glTexImage2D(GL_TEXTURE_2D,0,opaque?GL_RGB8:GL_RGBA8,w,h,0,GL_RGBA,GL_UNSIGNED_BYTE,pixels);
        i->second.w=w; i->second.h=h; i->second.opaque=opaque;
    } else {
        glTexSubImage2D(GL_TEXTURE_2D,0,0,0,w,h,GL_RGBA,GL_UNSIGNED_BYTE,pixels);
    }
    uploadBytes+=(uint64_t)w*h*4;
}
API void mpGpuBegin() {
    if(!current()) return;
    uploadBytes=drawCalls=0; vertices.clear(); batchTexture=0;
    bindFbo(FBO,fbo); drawing=true; glViewport(0,0,width,height); ortho(width,height);
    glDisable(GL_DEPTH_TEST); glDisable(GL_CULL_FACE); glDisable(GL_SCISSOR_TEST); glDisable(GL_DITHER);
    glEnable(GL_TEXTURE_2D); glEnable(GL_BLEND); glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
    // The scene target is opaque; retain alpha=1 through every source-over pass.
    glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_FALSE);
}
API void mpGpuClear(uint32_t color) {
    if(!current()) return;
    flush();
    glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_TRUE);
    glClearColor(((color>>24)&255)/255.f,((color>>16)&255)/255.f,((color>>8)&255)/255.f,1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_FALSE);
}
API void mpGpuSprite(int id,int iw,int ih,int sx,int sy,int sw,int sh,int x,int y,int dw,int dh,uint32_t color) {
    if(!current() || !id || iw<=0 || ih<=0 || sw<=0 || sh<=0 || dw<=0 || dh<=0) return;
    quad(id,(float)x,(float)y,(float)dw,(float)dh,(float)sx/iw,(float)sy/ih,(float)(sx+sw)/iw,(float)(sy+sh)/ih,color);
}
API void mpGpuRect(int x,int y,int w,int h,uint32_t color) {
    if(w>0 && h>0) quad(white,(float)x,(float)y,(float)w,(float)h,0,0,1,1,color);
}
API void mpGpuCircle(int cx,int cy,int r,uint32_t color) {
    if(r<0) return;
    int x=r,y=0,decision=1-r;
    while(y<=x){
        mpGpuRect(cx-x,cy+y,x*2+1,1,color); if(y)mpGpuRect(cx-x,cy-y,x*2+1,1,color);
        if(x!=y){mpGpuRect(cx-y,cy+x,y*2+1,1,color);if(x)mpGpuRect(cx-y,cy-x,y*2+1,1,color);}
        ++y; if(decision<0)decision+=2*y+1;else{--x;decision+=2*(y-x)+1;}
    }
}
API void mpGpuLine(int x0,int y0,int x1,int y1,uint32_t color) {
    int dx=std::abs(x1-x0),sx=x0<x1?1:-1,dy=-std::abs(y1-y0),sy=y0<y1?1:-1,err=dx+dy;
    for(;;) { mpGpuRect(x0,y0,1,1,color); if(x0==x1 && y0==y1) break; int e=2*err; if(e>=dy){err+=dy;x0+=sx;} if(e<=dx){err+=dx;y0+=sy;} }
}
// Screen blend light: a small reusable RGB falloff texture; application supplies
// a black-exclusion mask through the shader in the later light pass below.
using CreateShaderFn=GLuint(APIENTRY*)(GLenum); using SourceFn=void(APIENTRY*)(GLuint,GLsizei,const char* const*,const GLint*);
using ShaderFn=void(APIENTRY*)(GLuint); using CreateProgramFn=GLuint(APIENTRY*)(); using AttachShaderFn=void(APIENTRY*)(GLuint,GLuint);
using GetIvFn=void(APIENTRY*)(GLuint,GLenum,GLint*); using UniformLocFn=GLint(APIENTRY*)(GLuint,const char*);
using Uniform4Fn=void(APIENTRY*)(GLint,GLfloat,GLfloat,GLfloat,GLfloat);
static GLuint lightProgram=0; static ShaderFn useProgram=nullptr,deleteProgram=nullptr;
static UniformLocFn uniformLocation; static Uniform4Fn uniform4;
static void destroyLight() { if(lightProgram && deleteProgram) deleteProgram(lightProgram); lightProgram=0; }
static bool createLightShader() {
    auto createShader=(CreateShaderFn)proc("glCreateShader"); auto source=(SourceFn)proc("glShaderSource");
    auto compile=(ShaderFn)proc("glCompileShader"); auto getShader=(GetIvFn)proc("glGetShaderiv");
    auto createProgram=(CreateProgramFn)proc("glCreateProgram"); auto attach=(AttachShaderFn)proc("glAttachShader");
    auto link=(ShaderFn)proc("glLinkProgram"); auto getProgram=(GetIvFn)proc("glGetProgramiv");
    auto deleteShader=(ShaderFn)proc("glDeleteShader"); useProgram=(ShaderFn)proc("glUseProgram");
    deleteProgram=(ShaderFn)proc("glDeleteProgram"); uniformLocation=(UniformLocFn)proc("glGetUniformLocation"); uniform4=(Uniform4Fn)proc("glUniform4f");
    if(!createShader || !source || !compile || !getShader || !createProgram || !attach || !link || !getProgram || !deleteShader || !useProgram || !deleteProgram || !uniformLocation || !uniform4) return false;
    const char* code="#version 120\nuniform sampler2D image; uniform vec4 shape; uniform vec4 power; void main(){vec2 pos=floor(gl_FragCoord.xy); vec2 d=vec2(pos.x-shape.x,shape.y-pos.y); float fall=256.0-floor(d.y*d.y*shape.w/65536.0)-floor(d.x*d.x*shape.z/65536.0); vec3 c=floor(texture2D(image,gl_TexCoord[0].xy).rgb*255.0+0.5); if(fall>0.0 && c.r+c.g+c.b>36.0){float a=floor(fall*fall/256.0); c+=floor((255.0-c)*power.rgb*a/65536.0);} gl_FragColor=vec4(c/255.0,1.0);}";
    GLuint shader=createShader(0x8B30); source(shader,1,&code,nullptr); compile(shader); GLint ok=0; getShader(shader,0x8B81,&ok);
    if(!ok) {deleteShader(shader); return false;}
    lightProgram=createProgram(); attach(lightProgram,shader); link(lightProgram); deleteShader(shader); getProgram(lightProgram,0x8B82,&ok);
    if(!ok) {deleteProgram(lightProgram); lightProgram=0; return false;} return true;
}
API int mpGpuLightReady() { return current() && (lightProgram || createLightShader()); }
API void mpGpuLight(int cx,int cy,int rx,int ry,int red,int green,int blue) {
    if(!current() || !lightProgram || rx<1 || ry<1) return;
    int x=std::max(0,cx-rx),y=std::max(0,cy-ry),x1=std::min(width,cx+rx+1),y1=std::min(height,cy+ry+1);
    int w=x1-x,h=y1-y; if(w<=0 || h<=0) return;
    flush(); if(!light) light=makeTexture(width,height,nullptr);
    glBindTexture(GL_TEXTURE_2D,light); glCopyTexSubImage2D(GL_TEXTURE_2D,0,x,height-y1,x,height-y1,w,h);
    useProgram(lightProgram); glDisable(GL_BLEND);
    double rx2=(double)rx*rx,ry2=(double)ry*ry;
    uniform4(uniformLocation(lightProgram,"shape"),(float)cx,(float)(height-1-cy),(float)(16777216.0/rx2),(float)(16777216.0/ry2));
    uniform4(uniformLocation(lightProgram,"power"),(float)red,(float)green,(float)blue,0);
    quad(light,(float)x,(float)y,(float)w,(float)h,(float)x/width,(float)(height-y)/height,(float)x1/width,(float)(height-y1)/height,0xffffffff); flush();
    useProgram(0); glEnable(GL_BLEND);
}
API void mpGpuRead(void* pixels) {
    if(!current() || !pixels) return;
    flush(); bindFbo(FBO,fbo); glReadPixels(0,0,width,height,GL_RGBA,GL_UNSIGNED_BYTE,pixels);
    auto p=(unsigned char*)pixels; std::vector<unsigned char> row(width*4);
    for(int y=0;y<height/2;++y){auto a=p+y*width*4,b=p+(height-1-y)*width*4;std::memcpy(row.data(),a,width*4);std::memcpy(a,b,width*4);std::memcpy(b,row.data(),width*4);}
    if(!drawing) bindFbo(FBO,0);
}
API void mpGpuEnd(int cw,int ch,int vx,int vy,int vw,int vh) {
    if(!current() || cw<1 || ch<1 || vw<1 || vh<1) return;
    flush(); bindFbo(FBO,0); drawing=false; glViewport(0,0,cw,ch); glClearColor(0,0,0,1); glClear(GL_COLOR_BUFFER_BIT);
    glViewport(vx,ch-vy-vh,vw,vh); ortho(width,height); glDisable(GL_BLEND);
    quad(scene,0,0,(float)width,(float)height,0,1,1,0,0xffffffff); flush(); glEnable(GL_BLEND);
}
API uint64_t mpGpuUploads() { return uploadBytes; }
API uint64_t mpGpuDrawCalls() { return drawCalls; }
