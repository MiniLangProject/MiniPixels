// Hidden, real OpenGL tests. No game assets or user files.
#include "../native/gpu_scene.cpp"
#include <stdexcept>
static void check(bool b,const char*m){if(!b)throw std::runtime_error(m);}
static StatusFn checkedStatus=nullptr;static int depthChecks=0;
static GLenum APIENTRY countStatus(GLenum target){++depthChecks;return checkedStatus(target);}
static std::vector<unsigned char> frame(int first,int second){
    mpGpuBegin();mpGpuClear(0x102030ff);
    check(mp3dBegin(0,0,2,128,80)==1,"begin");
    check(mp3dBegin(0,0,2,128,80)==0,"reject nested pass");
    check(mp3dMeshDraw(first)==1&&mp3dMeshDraw(second)==1,"draw meshes");
    mp3dEnd();mpGpuRect(4,4,16,16,0xffff00ff);
    std::vector<unsigned char> image(256*256*4);mpGpuRead(image.data());return image;
}
int main(int argc,char**argv){
    WNDCLASSW wc{};wc.style=CS_OWNDC;wc.lpfnWndProc=DefWindowProcW;
    wc.hInstance=GetModuleHandleW(nullptr);wc.lpszClassName=L"MiniPixels3DTests";RegisterClassW(&wc);
    HWND window=CreateWindowW(wc.lpszClassName,L"3D tests",WS_OVERLAPPEDWINDOW,0,0,256,256,nullptr,nullptr,wc.hInstance,nullptr);
    HDC dc=GetDC(window);PIXELFORMATDESCRIPTOR pf{sizeof(pf),1,PFD_DRAW_TO_WINDOW|PFD_SUPPORT_OPENGL|PFD_DOUBLEBUFFER,PFD_TYPE_RGBA,32};
    SetPixelFormat(dc,ChoosePixelFormat(dc,&pf),&pf);HGLRC context=wglCreateContext(dc);wglMakeCurrent(dc,context);
    try{
        check(wglGetCurrentContext()!=nullptr,"current OpenGL context");
        if(argc>1&&!strcmp(argv[1],"--allow-unavailable")&&!proc("glGenFramebuffers")){
            puts("SCENE3D_UNAVAILABLE: hosted OpenGL has no framebuffer support; native pixel checks skipped");
            wglMakeCurrent(nullptr,nullptr);wglDeleteContext(context);ReleaseDC(window,dc);DestroyWindow(window);return 0;
        }
        check(mpGpuInit(256,256)==1,"initialize");
        check(mp3dBegin(0,0,1,128,80)==0,"requires active canvas");
        check(mp3dMeshBegin()==1,"builder");check(mp3dMeshBegin()==0,"nested builder");
        check(mp3dBox(0,0,0,1,1,1,0xe04030ff)==1,"box");int front=mp3dMeshEnd();check(front>0,"upload front");
        check(mp3dMeshBegin()==1,"second mesh");check(mp3dBox(-1.1,-1.1,0,1,1,1,0x3090e0ff)==1,"back box");int back=mp3dMeshEnd();
        auto a=frame(front,back),b=frame(back,front);check(a==b,"depth independent of submission order");
        size_t changed=0;for(size_t i=0;i<a.size();i+=4)if(a[i]!=16||a[i+1]!=32||a[i+2]!=48)++changed;
        check(changed>1000,"real geometry visible");size_t p=(8*256+8)*4;
        check(a[p]==255&&a[p+1]==255&&a[p+2]==0,"2D overlay state restored");
        const unsigned char texels[16]={255,0,0,0,255,255,255,255,255,0,0,0,255,255,255,255};
        int texture=mpGpuTexture(texels,2,2,false);check(texture>0,"cutout source");
        mpGpuBegin();mpGpuClear(0x102030ff);check(mp3dBegin(0,0,2,128,80)==1,"cutout pass");
        check(mp3dSprite(texture,2,2,0,0,2,2,100,100,80,80,0,180,0xffffffff)==1,"cutout draw");
        check(mp3dSprite(texture,2,2,1,0,2,2,100,100,80,80,0,180,0xffffffff)==0,"invalid texture bounds");
        mp3dEnd();std::vector<unsigned char> cutout(256*256*4);mpGpuRead(cutout.data());
        check(cutout[(120*256+110)*4]==16,"transparent cutout leaves background");
        check(cutout[(120*256+160)*4]==255,"opaque cutout is visible");
        mpGpuBegin();check(mp3dBegin(0,0,2,128,80)==1,"instance pass");
        check(mp3dMeshDrawAt(front,1,0,0,45,1,1,1)==1,"transformed mesh");
        check(mp3dMeshDrawAt(front,0,0,0,0,-1,1,1)==0,"invalid instance rejected");mp3dEnd();
        check(glGetError()==GL_NO_ERROR,"clean GL state");
        mpGpuBegin();check(mp3dBegin(0,0,1,0,0)==1,"seed projected depth test");
        glClearDepth(.25);glClear(GL_DEPTH_BUFFER_BIT);mp3dEnd();
        check(mp3dBeginProjected(20,30,40,50,2.2)==1,"projected viewport");
        float inside=0,outside=0;
        glReadPixels(30,256-40,1,1,GL_DEPTH_COMPONENT,GL_FLOAT,&inside);
        glReadPixels(100,100,1,1,GL_DEPTH_COMPONENT,GL_FLOAT,&outside);
        check(inside>.999f&&outside>.249f&&outside<.251f,"only projected rectangle depth is cleared");
        mp3dEnd();
        // Public scopes must keep the general texture contract even though
        // the private owned-2D hook may opt out of these snapshots.
        for(bool projected:{false,true}){
            mp3d::activeTexture(0x84C0);glBindTexture(GL_TEXTURE_2D,GLuint(texture));
            mp3d::activeTexture(0x84C3);glBindTexture(GL_TEXTURE_2D,GLuint(texture));
            glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE);
            check(projected?mp3dBeginProjected(20,30,40,50,2.2):mp3dBegin(0,0,1,0,0),"public texture-state pass");
            mp3d::activeTexture(0x84C0);glBindTexture(GL_TEXTURE_2D,0);
            mp3d::activeTexture(0x84C3);glBindTexture(GL_TEXTURE_2D,0);
            glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);mp3dEnd();
            GLint restored=0;glGetIntegerv(0x84E0,&restored);check(restored==0x84C3,"active texture restored");
            glGetIntegerv(GL_TEXTURE_BINDING_2D,&restored);check(restored==texture,"secondary texture binding restored");
            glGetTexEnviv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,&restored);check(restored==GL_REPLACE,"texture environment restored");
            glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);glBindTexture(GL_TEXTURE_2D,0);
            mp3d::activeTexture(0x84C0);glGetIntegerv(GL_TEXTURE_BINDING_2D,&restored);check(restored==texture,"primary texture binding restored");
        }
        checkedStatus=statusFbo;statusFbo=countStatus;
        for(int actor=0;actor<50;++actor){check(mp3dBeginProjected(20,30,40,50,2.2)==1,"repeated projected pass");mp3dEnd();}
        check(depthChecks==0,"stable depth attachment is not revalidated per actor");statusFbo=checkedStatus;
        check(mp3dMeshBegin()==1,"invalid builder");check(mp3dBox(0,0,0,-1,1,1,0)==0,"invalid extent");check(mp3dMeshEnd()==0,"invalid build never published");
        auto bytes=mp3dMetric(2);check(bytes==72*sizeof(mp3d::Point),"resident accounting");
        mpGpuEnd(256,256,0,0,256,256);check(mpGpuResize(320,200)==1,"resize");
        mpGpuBegin();depthChecks=0;statusFbo=countStatus;
        check(mp3dBegin(0,0,1,100,100)==1,"depth resized");check(depthChecks==1,"resized scene validates new depth attachment");statusFbo=checkedStatus;
        check(mp3dMeshDraw(front)==1,"mesh survives resize");
        mp3dEnd();mpGpuEnd(320,200,0,0,320,200);
        // Two resizes without an intervening 3D draw may recycle BOTH FBO and
        // texture names. Numeric-name equality must not bypass reattachment.
        check(mpGpuResize(256,256)&&mpGpuResize(320,200),"round-trip resize without 3D draw");
        check(mp3d::depthFramebuffer==0,"resize invalidates attachment identity explicitly");
        mpGpuBegin();depthChecks=0;statusFbo=countStatus;
        check(mp3dBeginProjected(20,30,40,50,2.2)==1&&depthChecks==1,"round-trip scene depth reattached");
        statusFbo=checkedStatus;mp3dEnd();
        mp3dMeshDelete(front);mp3dMeshDelete(front);check(mp3dMetric(3)==1,"idempotent release");
        mpGpuShutdown();check(mp3dMetric(2)==0&&mp3dMetric(3)==0,"shutdown releases 3D resources");
        check(mpGpuInit(256,256)==1,"reinitialize");mpGpuBegin();check(mp3dBegin(0,0,1,100,100)==1,"new pass");
        check(mp3dMeshDraw(back)==0,"stale handles rejected");mpGpuShutdown();
        check(!mp3d::active&&mp3dMetric(3)==0,"shutdown unwinds an interrupted pass");
        puts("PASS scene3d: depth, visibility, 2D restoration, validation, resize, ownership, context lifecycle");
    }catch(const std::exception&e){fprintf(stderr,"FAIL: %s\n",e.what());return 1;}
    wglMakeCurrent(nullptr,nullptr);wglDeleteContext(context);ReleaseDC(window,dc);DestroyWindow(window);return 0;
}
