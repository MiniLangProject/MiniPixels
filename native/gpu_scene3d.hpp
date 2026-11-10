// SPDX-License-Identifier: Apache-2.0
// Optional retained 3D geometry sharing the 2D scene target. Windows/OpenGL.
#pragma once
#include <limits>
namespace mp3d {
struct Point { float x,y,z; uint32_t rgba; };
struct Mesh { GLuint buffer; GLsizei count; };
using BufferData=void(APIENTRY*)(GLenum,ptrdiff_t,const void*,GLenum);
using Active=void(APIENTRY*)(GLenum);
static GenFn genBuffer=nullptr; static BindFn bindBuffer=nullptr;
static DeleteFn deleteBuffer=nullptr; static BufferData bufferData=nullptr;
static ShaderFn program=nullptr; static Active activeTexture=nullptr;
static std::unordered_map<int,Mesh> meshes;
static std::vector<Point> builder;
static int nextHandle=1; static bool building=false,failed=false,active=false;
static GLuint depth=0; static int depthW=0,depthH=0;
static GLuint depthFramebuffer=0,depthScene=0;
static void invalidateDepthAttachment(){depthFramebuffer=depthScene=0;}
static GLint oldProgram=0,oldFramebuffer=0,oldMatrixMode=0,oldActive=0;
static GLint oldArray=0,oldElements=0;
static double view[16]{};
static uint64_t draws=0,triangles=0,resident=0;
static bool finite(double x){return std::isfinite(x)&&std::abs(x)<1000000.;}
static uint32_t color(uint32_t c,double shade=1){
    auto part=[&](int s){return uint32_t(((c>>s)&255)*shade);};
    return part(24)|(part(16)<<8)|(part(8)<<16)|(c<<24);
}
static bool readyFunctions(){
    if(genBuffer)return true;
    auto g=(GenFn)proc("glGenBuffers"); auto b=(BindFn)proc("glBindBuffer");
    auto d=(DeleteFn)proc("glDeleteBuffers"); auto data=(BufferData)proc("glBufferData");
    auto p=(ShaderFn)proc("glUseProgram"); auto a=(Active)proc("glActiveTexture");
    if(!g||!b||!d||!data||!p||!a)return false;
    genBuffer=g;bindBuffer=b;deleteBuffer=d;bufferData=data;program=p;activeTexture=a;return true;
}
static void reset(){
    if(!current())return;
    if(active)mp3dEnd();
    for(auto&m:meshes)deleteBuffer(1,&m.second.buffer);
    meshes.clear();builder.clear();building=false;resident=0;
    if(depth)glDeleteTextures(1,&depth);depth=0;depthW=depthH=0;
    depthFramebuffer=depthScene=0;
}
// Model coordinates: X across screen, Y up, Z towards the viewer.
// World coordinates: tile X/Y, elevation Z. Scale is unzoomed pixels/metre.
static void actor(double x,double y,double z,double scale,double heading){
    glMatrixMode(GL_MODELVIEW);glLoadMatrixd(view);
    glTranslated(x,y,z);
    const double s=scale/64.;
    const double model[16]={s,-s,0,0, 0,0,2*s,0, s,s,0,0, 0,0,0,1};
    glMultMatrixd(model);glRotated(-heading*45.,0,1,0);
}
}

static int mp3dBeginPass(double cameraX,double cameraY,double zoom,double centerX,double centerY,bool clearDepth,bool owned2D=false,GLuint ownedFramebuffer=0,bool projected=false,bool rebindTextures=false){
    using namespace mp3d;
    if(!current()||!drawing||active||!finite(cameraX)||!finite(cameraY)||!finite(zoom)||zoom<=0||zoom>64||!finite(centerX)||!finite(centerY)||!readyFunctions())return 0;
    flush();
    if(owned2D){
        // Internal integration hook: the caller owns the complete 2D pipeline
        // and supplies its tracked FBO. Public API calls always query state.
        oldProgram=oldArray=oldElements=0;oldFramebuffer=GLint(ownedFramebuffer);
        oldMatrixMode=GL_MODELVIEW;oldActive=0x84C0;
    }else{
        glGetIntegerv(0x8B8D,&oldProgram);glGetIntegerv(0x8CA6,&oldFramebuffer);
        glGetIntegerv(GL_MATRIX_MODE,&oldMatrixMode);glGetIntegerv(0x84E0,&oldActive);
        glGetIntegerv(0x8894,&oldArray);glGetIntegerv(0x8895,&oldElements);
    }
    // Save exactly the mutable 3D state. The owned integration rebinds every
    // sampler before use and invalidates the 2D batch binding on exit; copying
    // every texture unit's bindings/environment is unnecessary there. Public
    // scopes continue to preserve all caller texture state.
    glPushAttrib(GL_ENABLE_BIT|GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_VIEWPORT_BIT|
        GL_SCISSOR_BIT|GL_POLYGON_BIT|(owned2D&&rebindTextures?0:GL_TEXTURE_BIT)|GL_CURRENT_BIT|GL_TRANSFORM_BIT);
    glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT);
    bindFbo(FBO,fbo);activeTexture(0x84C0);
    if(depthW!=width||depthH!=height){
        depthFramebuffer=depthScene=0;
        if(depth)glDeleteTextures(1,&depth);
        glGenTextures(1,&depth);glBindTexture(GL_TEXTURE_2D,depth);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
        glTexImage2D(GL_TEXTURE_2D,0,0x81A6,width,height,0,GL_DEPTH_COMPONENT,GL_UNSIGNED_INT,nullptr);
        depthW=width;depthH=height;
    }
    // This backend exclusively owns the scene's depth attachment. Validate
    // on allocation/resize, not for every actor. Include the colour identity
    // so a reused FBO name cannot retain the previous attachment's validity.
    if(depthFramebuffer!=fbo||depthScene!=scene){
        attachFbo(FBO,0x8D00,GL_TEXTURE_2D,depth,0);
        if(statusFbo(FBO)!=0x8CD5){bindFbo(FBO,oldFramebuffer);glPopClientAttrib();glPopAttrib();return 0;}
        depthFramebuffer=fbo;depthScene=scene;
    }
    glViewport(0,0,width,height);program(0);bindBuffer(0x8892,0);bindBuffer(0x8893,0);
    glDisable(GL_SCISSOR_TEST);glDisable(GL_BLEND);glDisable(GL_CULL_FACE);glDisable(GL_TEXTURE_2D);
    glEnable(GL_DEPTH_TEST);glDepthFunc(GL_LEQUAL);glDepthMask(GL_TRUE);
    glColorMask(GL_TRUE,GL_TRUE,GL_TRUE,GL_FALSE);glClearDepth(1);if(clearDepth)glClear(GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);glPushMatrix();
    glMatrixMode(GL_MODELVIEW);glPushMatrix();
    if(!projected){
    glMatrixMode(GL_PROJECTION);glLoadIdentity();glOrtho(0,width,height,0,-65536,65536);
    glMatrixMode(GL_MODELVIEW);
    const double v[16]={32*zoom,16*zoom,27.7128129211*zoom,0,
      -32*zoom,16*zoom,27.7128129211*zoom,0,
      0,-27.7128129211*zoom,16*zoom,0,
      centerX-cameraX*zoom,centerY-cameraY*zoom,-cameraY*1.73205080757*zoom,1};
    std::copy(v,v+16,view);glLoadMatrixd(view);
    }
    active=true;draws=triangles=0;return 1;
}
API int mp3dBegin(double cameraX,double cameraY,double zoom,double centerX,double centerY){
    return mp3dBeginPass(cameraX,cameraY,zoom,centerX,centerY,true);
}
API void mp3dEnd(){
    using namespace mp3d;if(!active||!current())return;
    glMatrixMode(GL_MODELVIEW);glPopMatrix();glMatrixMode(GL_PROJECTION);glPopMatrix();
    glPopClientAttrib();glPopAttrib();program(oldProgram);activeTexture(oldActive);
    bindBuffer(0x8892,oldArray);bindBuffer(0x8893,oldElements);
    glMatrixMode(oldMatrixMode);bindFbo(FBO,oldFramebuffer);batchTexture=0;active=false;
}

// A model viewport projected directly into the scene, with the same camera
// space (and normal matrix) as an authored orthographic render. The shared
// depth attachment starts clean for the authored painter order; colour stays.
// This supports mixed authored 2.5D scenery and live skeletal geometry.
static int mp3dBeginProjectedPass(double x,double y,int w,int h,double halfExtent,bool owned2D,GLuint ownedFramebuffer,bool rebindTextures=false){
    using namespace mp3d;
    if(!finite(x)||!finite(y)||w<1||h<1||w>4096||h>4096||!finite(halfExtent)||halfExtent<=0)return 0;
    if(!mp3dBeginPass(0,0,1,0,0,false,owned2D,ownedFramebuffer,owned2D&&rebindTextures,rebindTextures))return 0;
    glEnable(GL_SCISSOR_TEST);
    const int left=std::max(0,int(std::floor(x))),right=std::min(width,int(std::ceil(x+w)));
    const int top=std::max(0,int(std::floor(y))),bottom=std::min(height,int(std::ceil(y+h)));
    glScissor(left,height-bottom,std::max(0,right-left),std::max(0,bottom-top));
    // Only this model's viewport needs a clean depth buffer. Clearing the
    // complete 4K scene for each actor makes cost scale with screen area.
    glClear(GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);glLoadIdentity();glOrtho(0,width,height,0,-10,10);
    glTranslated(x+w*.5,y+h*.5,0);glScaled(w/(2*halfExtent),-h/(2*halfExtent),1);
    // The reference pose is a top-down texture. Its final texture flip is now
    // in the projection, so reverse winding too: shaders using gl_FrontFacing
    // (lined robes, hair shells) must see the same side as in the reference.
    GLint winding=GL_CCW;if(!owned2D)glGetIntegerv(GL_FRONT_FACE,&winding);
    glFrontFace(winding==GL_CCW?GL_CW:GL_CCW);
    glMatrixMode(GL_MODELVIEW);glLoadIdentity();
    return 1;
}
API int mp3dBeginProjected(double x,double y,int w,int h,double halfExtent){
    return mp3dBeginProjectedPass(x,y,w,h,halfExtent,false,0);
}
API int mp3dMeshBegin(){
    if(!current()||mp3d::building||!mp3d::readyFunctions())return 0;
    mp3d::builder.clear();mp3d::building=true;mp3d::failed=false;return 1;
}
API int mp3dBox(double x,double y,double z,double sx,double sy,double sz,uint32_t rgba){
    using namespace mp3d;
    if(!building)return 0;
    if(!finite(x)||!finite(y)||!finite(z)||!finite(sx)||!finite(sy)||!finite(sz)||sx<=0||sy<=0||sz<=0||builder.size()>3000000-36){failed=true;return 0;}
    Point p[8];for(int i=0;i<8;++i)p[i]={float(x+(i&1?sx:0)),float(y+(i&2?sy:0)),float(z+(i&4?sz:0)),0};
    const int faces[6][4]={{0,2,3,1},{4,5,7,6},{0,1,5,4},{2,6,7,3},{0,4,6,2},{1,3,7,5}};
    const double light[6]={.45,1.,.70,.82,.65,.88};
    for(int f=0;f<6;++f)for(int i:{0,1,2,0,2,3}){Point v=p[faces[f][i]];v.rgba=color(rgba,light[f]);builder.push_back(v);}
    return 1;
}
API int mp3dMeshEnd(){
    using namespace mp3d;if(!building)return 0;building=false;
    if(failed||builder.empty()||!current()||nextHandle==INT_MAX){builder.clear();return 0;}
    GLint previous=0;glGetIntegerv(0x8894,&previous);
    GLuint buffer=0;genBuffer(1,&buffer);bindBuffer(0x8892,buffer);
    const auto bytes=builder.size()*sizeof(Point);bufferData(0x8892,ptrdiff_t(bytes),builder.data(),0x88E4);
    GLint actual=0;auto get=(void(APIENTRY*)(GLenum,GLenum,GLint*))proc("glGetBufferParameteriv");
    if(get)get(0x8892,0x8764,&actual);bindBuffer(0x8892,previous);
    if(!buffer||actual!=bytes){if(buffer)deleteBuffer(1,&buffer);builder.clear();return 0;}
    int handle=nextHandle++;meshes.emplace(handle,Mesh{buffer,GLsizei(builder.size())});resident+=bytes;builder.clear();return handle;
}
static int mp3dDrawMesh(int handle,double x=0,double y=0,double z=0,double yaw=0,double sx=1,double sy=1,double sz=1){
    using namespace mp3d;if(!active||!current())return 0;
    if(!finite(x)||!finite(y)||!finite(z)||!finite(yaw)||!finite(sx)||!finite(sy)||!finite(sz)||sx<=0||sy<=0||sz<=0)return 0;
    auto m=meshes.find(handle);if(m==meshes.end())return 0;
    program(0);activeTexture(0x84C0);glDisable(GL_TEXTURE_2D);glDisable(GL_BLEND);glDepthMask(GL_TRUE);
    glMatrixMode(GL_MODELVIEW);glLoadMatrixd(view);glTranslated(x,y,z);glRotated(yaw,0,0,1);glScaled(sx,sy,sz);bindBuffer(0x8892,m->second.buffer);bindBuffer(0x8893,0);
    glEnableClientState(GL_VERTEX_ARRAY);glEnableClientState(GL_COLOR_ARRAY);glDisableClientState(GL_NORMAL_ARRAY);glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glVertexPointer(3,GL_FLOAT,sizeof(Point),(void*)0);glColorPointer(4,GL_UNSIGNED_BYTE,sizeof(Point),(void*)12);
    // Avoid the game's 2D glDrawArrays interception: this buffer is 3D vertices.
    auto draw=(void(APIENTRY*)(GLenum,GLint,GLsizei))GetProcAddress(GetModuleHandleW(L"opengl32.dll"),"glDrawArrays");
    draw(GL_TRIANGLES,0,m->second.count);++draws;++drawCalls;triangles+=m->second.count/3;
    glDisableClientState(GL_COLOR_ARRAY);glDisableClientState(GL_VERTEX_ARRAY);bindBuffer(0x8892,0);return 1;
}
API void mp3dMeshDelete(int handle){
    using namespace mp3d;if(!current())return;auto m=meshes.find(handle);if(m==meshes.end())return;
    resident-=uint64_t(m->second.count)*sizeof(Point);deleteBuffer(1,&m->second.buffer);meshes.erase(m);
}
API uint64_t mp3dMetric(int field){return field==0?mp3d::draws:field==1?mp3d::triangles:field==2?mp3d::resident:field==3?mp3d::meshes.size():0;}

// Cutout billboard in the same depth convention as meshes. Rectangles are
// screen pixels; groundDepth is tile X+Y and footY the projected ground anchor.
// Transparent texels never write depth. Semi-transparent effects need a later,
// explicitly sorted pass and must not use this opaque/cutout operation.
API int mp3dSprite(int texture,int iw,int ih,int sx,int sy,int sw,int sh,
    double x,double y,double w,double h,double groundDepth,double footY,uint32_t rgba){
    using namespace mp3d;
    if(!active||!current()||texture<=0||iw<1||ih<1||sx<0||sy<0||sw<1||sh<1||
       int64_t(sx)+sw>iw||int64_t(sy)+sh>ih||!finite(x)||!finite(y)||!finite(w)||!finite(h)||w<=0||h<=0||!finite(groundDepth)||!finite(footY))return 0;
    program(0);activeTexture(0x84C0);glPushAttrib(GL_ENABLE_BIT|GL_COLOR_BUFFER_BIT|GL_TEXTURE_BIT|GL_DEPTH_BUFFER_BIT|GL_CURRENT_BIT);
    glEnable(GL_TEXTURE_2D);glBindTexture(GL_TEXTURE_2D,texture);glEnable(GL_ALPHA_TEST);glAlphaFunc(GL_GREATER,.5f);
    glDisable(GL_BLEND);glDepthMask(GL_TRUE);glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_MODELVIEW);glPushMatrix();glLoadIdentity();
    const double base=groundDepth*view[2]+view[14];
    const double top=base+(footY-y)*.57735026919,bottom=base+(footY-y-h)*.57735026919;
    const double u0=double(sx)/iw,v0=double(sy)/ih,u1=double(sx+sw)/iw,v1=double(sy+sh)/ih;
    glColor4ub(rgba>>24,(rgba>>16)&255,(rgba>>8)&255,rgba&255);
    glBegin(GL_QUADS);
    glTexCoord2d(u0,v0);glVertex3d(x,y,top);glTexCoord2d(u1,v0);glVertex3d(x+w,y,top);
    glTexCoord2d(u1,v1);glVertex3d(x+w,y+h,bottom);glTexCoord2d(u0,v1);glVertex3d(x,y+h,bottom);
    glEnd();glPopMatrix();glPopAttrib();++draws;++drawCalls;triangles+=2;return 1;
}

API int mp3dMeshDraw(int handle){return mp3dDrawMesh(handle);}
API int mp3dMeshDrawAt(int handle,double x,double y,double z,double yaw,double sx,double sy,double sz){return mp3dDrawMesh(handle,x,y,z,yaw,sx,sy,sz);}
