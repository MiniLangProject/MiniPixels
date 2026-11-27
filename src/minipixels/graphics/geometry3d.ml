// SPDX-License-Identifier: Apache-2.0
//! Portable CPU 3D geometry for a MiniPixels Canvas. Flat shaded triangles use
//! a 16-bit depth buffer and perspective-correct inverse-depth interpolation.
//! Geometry crossing the near plane is rejected, not clipped; choose a camera
//! that keeps the complete scene in front of it. RGBA textures support
//! perspective-correct UVs and alpha cutout, but not translucent blending.
package minipixels.graphics.geometry3d

import minipixels.graphics.canvas as cv
import minipixels.graphics.sprite as g3image
import minipixels.math.types as mt
import std.math as math

struct Camera
  centerX as float
  centerY as float
  scale as float
  targetX as float
  targetY as float
  targetZ as float
  sinPitch as float
  cosPitch as float
  sinYaw as float
  cosYaw as float
  distance as float
  perspective as bool
  nearPlane as float
end struct

struct Point
  x
  y
  z
end struct

struct Projected
  x as float
  y as float
  depth as float
  visible as bool
end struct

struct Triangle
  ax as float
  ay as float
  az as float
  bx as float
  by as float
  bz as float
  cx as float
  cy as float
  cz as float
  color as int
end struct

struct UV
  u
  v
end struct

struct Texture
  width as int
  height as int
  pixels as bytes
  opaque as bool
  tint as int
  alphaCutoff as int
  bilinear as bool
end struct

/// Repeating UVs for physical materials; the legacy Texture remains clamped.
struct RepeatingTexture
  width as int
  height as int
  pixels as bytes
  opaque as bool
  tint as int
  alphaCutoff as int
  bilinear as bool
end struct

struct TexturedTriangle
  a
  b
  c
  uvA
  uvB
  uvC
  material
  color as int
end struct

struct Mesh
  triangles
  count as int
  capacity as int
  albedo
  lighting
end struct

struct Surface
  canvas
  depth as bytes
  width as int
  height as int
  triangles as int
end struct

/// Creates a camera looking towards increasing Y with upward world Z.
function camera(centerX, centerY, scale, targetX=0.0, targetY=0.6, targetZ=0.0, pitch=0.94, yaw=0.0, distance=2.6, perspective=true)
  return Camera(toFloat(centerX),toFloat(centerY),toFloat(scale),toFloat(targetX),toFloat(targetY),toFloat(targetZ),toFloat(math.sin(pitch)),toFloat(math.cos(pitch)),toFloat(math.sin(yaw)),toFloat(math.cos(yaw)),toFloat(distance),perspective,0.05)
end function

/// A finite point source. Intensity falls smoothly to zero at range.
struct PointLight
  x
  y
  z
  color
  intensity
  range
end struct

/// World-space illumination shared by meshes. Direction points toward the key.
struct Lighting
  x
  y
  z
  ambient
  color
  intensity
  points
  shadow
  shadowCamera
  shadowBias
end struct

/// Creates a normalized directional source and a colored ambient contribution.
function lighting(x=-0.32,y=-0.43,z=0.84,ambient=0x454952ff,color=0xffefd9ff,intensity=0.86)
  length = math.sqrt(x*x+y*y+z*z)
  if length < 0.0000001 then x = 0.0; y = 0.0; z = 1.0; length = 1.0 end if
  return Lighting(x/length,y/length,z/length,ambient,color,math.max(0.0,intensity),[],void,void,0.0025)
end function

/// Adds a colored lamp; range and intensity are clamped to nonnegative values.
function addPointLight(lights,x,y,z,color,intensity=1.0,range=0.25)
  lights.points = lights.points + [PointLight(x,y,z,color,math.max(0.0,intensity),math.max(0.00001,range))]
end function

/// Computes Lambert diffuse and a view-dependent Blinn specular highlight.
/// Albedo is retained separately from the legacy baked triangle color.
function illuminate(color,nx,ny,nz,x,y,z,c,lights,specular=0.0,shininess=48)
  normalLength = math.sqrt(nx*nx+ny*ny+nz*nz)
  if normalLength < 0.0000001 then return color end if
  nx=nx/normalLength; ny=ny/normalLength; nz=nz/normalLength
  red = ((lights.ambient>>24)&255)/255.0
  green = ((lights.ambient>>16)&255)/255.0
  blue = ((lights.ambient>>8)&255)/255.0
  key = math.max(0.0,nx*lights.x+ny*lights.y+nz*lights.z)*lights.intensity
  visibility=1.0
  if typeof(lights.shadow) != "void" then visibility=shadowVisibility(lights.shadow,lights.shadowCamera,x,y,z,lights.shadowBias) end if
  key=key*visibility
  red=red+key*((lights.color>>24)&255)/255.0
  green=green+key*((lights.color>>16)&255)/255.0
  blue=blue+key*((lights.color>>8)&255)/255.0
  vx=c.targetX-c.sinYaw*c.cosPitch*c.distance-x
  vy=c.targetY-c.cosYaw*c.cosPitch*c.distance-y
  vz=c.targetZ+c.sinPitch*c.distance-z
  viewLength=math.sqrt(vx*vx+vy*vy+vz*vz)
  if viewLength < 0.0000001 then viewLength=1.0 end if
  vx=vx/viewLength; vy=vy/viewLength; vz=vz/viewLength
  shineRed=0.0; shineGreen=0.0; shineBlue=0.0
  if specular > 0.0 and key > 0.0 then
    hx=lights.x+vx; hy=lights.y+vy; hz=lights.z+vz
    halfLength=math.sqrt(hx*hx+hy*hy+hz*hz)
    if halfLength > 0.0000001 then
      shine=math.powi(math.max(0.0,(nx*hx+ny*hy+nz*hz)/halfLength),shininess)*specular*lights.intensity*visibility
      shineRed=shine*((lights.color>>24)&255)
      shineGreen=shine*((lights.color>>16)&255)
      shineBlue=shine*((lights.color>>8)&255)
    end if
  end if
  if len(lights.points) > 0 then
  for i=0 to len(lights.points)-1
    lamp=lights.points[i]
    lx=lamp.x-x; ly=lamp.y-y; lz=lamp.z-z
    distanceSquared=lx*lx+ly*ly+lz*lz
    if distanceSquared < lamp.range*lamp.range and distanceSquared > 0.000000001 then
      distance=math.sqrt(distanceSquared)
      lx=lx/distance; ly=ly/distance; lz=lz/distance
      attenuation=1.0-distance/lamp.range
      attenuation=attenuation*attenuation*lamp.intensity
      diffuse=math.max(0.0,nx*lx+ny*ly+nz*lz)*attenuation
      red=red+diffuse*((lamp.color>>24)&255)/255.0
      green=green+diffuse*((lamp.color>>16)&255)/255.0
      blue=blue+diffuse*((lamp.color>>8)&255)/255.0
      if specular > 0.0 and diffuse > 0.0 then
        hx=lx+vx; hy=ly+vy; hz=lz+vz
        halfLength=math.sqrt(hx*hx+hy*hy+hz*hz)
        if halfLength > 0.0000001 then
          shine=math.powi(math.max(0.0,(nx*hx+ny*hy+nz*hz)/halfLength),shininess)*specular*attenuation
          shineRed=shineRed+shine*((lamp.color>>24)&255)
          shineGreen=shineGreen+shine*((lamp.color>>16)&255)
          shineBlue=shineBlue+shine*((lamp.color>>8)&255)
        end if
      end if
    end if
  end for
  end if
  r=math.clamp(math.floorInt(((color>>24)&255)*red+shineRed),0,255)
  g=math.clamp(math.floorInt(((color>>16)&255)*green+shineGreen),0,255)
  b=math.clamp(math.floorInt(((color>>8)&255)*blue+shineBlue),0,255)
  return (r<<24)|(g<<16)|(b<<8)|(color&255)
end function

/// Draws actual world-space illumination after object rotation and scaling.
/// Unlit triangles remain emissive. Flat shading is evaluated per face.
function drawLitAt(s,m,c,lights,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0,specular=0.0,shininess=48,cullBackfaces=true)
  if m.count <= 0 then return end if
  ca=math.cos(angle); sa=math.sin(angle)
  for i=0 to m.count-1
    t=m.triangles[i]
    a=void; b=void; d=void
    if t is TexturedTriangle then
      a=Point(tx+t.a.x*sx*ca-t.a.y*sy*sa,ty+t.a.x*sx*sa+t.a.y*sy*ca,tz+t.a.z*sz)
      b=Point(tx+t.b.x*sx*ca-t.b.y*sy*sa,ty+t.b.x*sx*sa+t.b.y*sy*ca,tz+t.b.z*sz)
      d=Point(tx+t.c.x*sx*ca-t.c.y*sy*sa,ty+t.c.x*sx*sa+t.c.y*sy*ca,tz+t.c.z*sz)
    else
      a=Point(tx+t.ax*sx*ca-t.ay*sy*sa,ty+t.ax*sx*sa+t.ay*sy*ca,tz+t.az*sz)
      b=Point(tx+t.bx*sx*ca-t.by*sy*sa,ty+t.bx*sx*sa+t.by*sy*ca,tz+t.bz*sz)
      d=Point(tx+t.cx*sx*ca-t.cy*sy*sa,ty+t.cx*sx*sa+t.cy*sy*ca,tz+t.cz*sz)
    end if
    color=m.albedo[i]
    ux=b.x-a.x; uy=b.y-a.y; uz=b.z-a.z
    vx=d.x-a.x; vy=d.y-a.y; vz=d.z-a.z
    nx=uy*vz-uz*vy; ny=uz*vx-ux*vz; nz=ux*vy-uy*vx
    centerX=(a.x+b.x+d.x)/3.0; centerY=(a.y+b.y+d.y)/3.0; centerZ=(a.z+b.z+d.z)/3.0
    viewX=c.targetX-c.sinYaw*c.cosPitch*c.distance-centerX
    viewY=c.targetY-c.cosYaw*c.cosPitch*c.distance-centerY
    viewZ=c.targetZ+c.sinPitch*c.distance-centerZ
    if cullBackfaces and m.lighting[i] and nx*viewX+ny*viewY+nz*viewZ <= 0.0 then continue end if
    if m.lighting[i] then
      color=illuminate(color,nx,ny,nz,centerX,centerY,centerZ,c,lights,specular,shininess)
    end if
    aa=project(c,a.x,a.y,a.z); bb=project(c,b.x,b.y,b.z); dd=project(c,d.x,d.y,d.z)
    if t is TexturedTriangle then
      rasterTexturedTriangle(s,aa,bb,dd,t.uvA,t.uvB,t.uvC,t.material,color,c.perspective)
    else
      rasterTriangle(s,aa,bb,dd,color,c.perspective)
    end if
  end for
end function

/// Bakes a fixed pose's world lighting into an immutable mesh in world space.
/// Use drawAt for subsequent frames; rebake after changing view or lights.
function bakeLitMesh(m,c,lights,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0,specular=0.0,shininess=48)
  result=mesh(m.count)
  if m.count <= 0 then return result end if
  ca=math.cos(angle); sa=math.sin(angle)
  for i=0 to m.count-1
    t=m.triangles[i]
    a=void; b=void; d=void
    if t is TexturedTriangle then
      a=Point(tx+t.a.x*sx*ca-t.a.y*sy*sa,ty+t.a.x*sx*sa+t.a.y*sy*ca,tz+t.a.z*sz)
      b=Point(tx+t.b.x*sx*ca-t.b.y*sy*sa,ty+t.b.x*sx*sa+t.b.y*sy*ca,tz+t.b.z*sz)
      d=Point(tx+t.c.x*sx*ca-t.c.y*sy*sa,ty+t.c.x*sx*sa+t.c.y*sy*ca,tz+t.c.z*sz)
    else
      a=Point(tx+t.ax*sx*ca-t.ay*sy*sa,ty+t.ax*sx*sa+t.ay*sy*ca,tz+t.az*sz)
      b=Point(tx+t.bx*sx*ca-t.by*sy*sa,ty+t.bx*sx*sa+t.by*sy*ca,tz+t.bz*sz)
      d=Point(tx+t.cx*sx*ca-t.cy*sy*sa,ty+t.cx*sx*sa+t.cy*sy*ca,tz+t.cz*sz)
    end if
    color=m.albedo[i]
    if m.lighting[i] then
      ux=b.x-a.x; uy=b.y-a.y; uz=b.z-a.z; vx=d.x-a.x; vy=d.y-a.y; vz=d.z-a.z
      nx=uy*vz-uz*vy; ny=uz*vx-ux*vz; nz=ux*vy-uy*vx
      centerX=(a.x+b.x+d.x)/3.0; centerY=(a.y+b.y+d.y)/3.0; centerZ=(a.z+b.z+d.z)/3.0
      viewX=c.targetX-c.sinYaw*c.cosPitch*c.distance-centerX
      viewY=c.targetY-c.cosYaw*c.cosPitch*c.distance-centerY
      viewZ=c.targetZ+c.sinPitch*c.distance-centerZ
      if nx*viewX+ny*viewY+nz*viewZ <= 0.0 then continue end if
      color=illuminate(color,nx,ny,nz,centerX,centerY,centerZ,c,lights,specular,shininess)
    end if
    if t is TexturedTriangle then
      texturedTriangle(result,a,b,d,t.uvA,t.uvB,t.uvC,t.material,false)
      result.triangles[result.count-1].color=color
      result.albedo[result.count-1]=color
    else
      triangle(result,a.x,a.y,a.z,b.x,b.y,b.z,d.x,d.y,d.z,color,false)
    end if
  end for
  return result
end function

/// Renders opaque mesh geometry from a light camera into a real depth map.
/// Transparent texture cutouts should use drawAt instead when they cast shadows.
function drawDepthAt(s,m,c,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0)
  if m.count <= 0 then return end if
  ca=math.cos(angle); sa=math.sin(angle)
  for i=0 to m.count-1
    t=m.triangles[i]
    a=void; b=void; d=void
    if t is TexturedTriangle then
      a=project(c,tx+t.a.x*sx*ca-t.a.y*sy*sa,ty+t.a.x*sx*sa+t.a.y*sy*ca,tz+t.a.z*sz)
      b=project(c,tx+t.b.x*sx*ca-t.b.y*sy*sa,ty+t.b.x*sx*sa+t.b.y*sy*ca,tz+t.b.z*sz)
      d=project(c,tx+t.c.x*sx*ca-t.c.y*sy*sa,ty+t.c.x*sx*sa+t.c.y*sy*ca,tz+t.c.z*sz)
    else
      a=project(c,tx+t.ax*sx*ca-t.ay*sy*sa,ty+t.ax*sx*sa+t.ay*sy*ca,tz+t.az*sz)
      b=project(c,tx+t.bx*sx*ca-t.by*sy*sa,ty+t.bx*sx*sa+t.by*sy*ca,tz+t.bz*sz)
      d=project(c,tx+t.cx*sx*ca-t.cy*sy*sa,ty+t.cx*sx*sa+t.cy*sy*ca,tz+t.cz*sz)
    end if
    rasterTriangle(s,a,b,d,0xffffffff,c.perspective)
  end for
end function

/// Samples a light's actual occluder depth, with four-tap soft edge filtering.
function shadowVisibility(shadow,lightCamera,x,y,z,bias=0.002) returns float
  var dx as float=toFloat(x-lightCamera.targetX)
  var dy as float=toFloat(y-lightCamera.targetY)
  var dz as float=toFloat(z-lightCamera.targetZ)
  var rx as float=toFloat(dx*lightCamera.cosYaw-dy*lightCamera.sinYaw)
  var ry as float=toFloat(dx*lightCamera.sinYaw+dy*lightCamera.cosYaw)
  var depth as float=toFloat(lightCamera.distance+ry*lightCamera.cosPitch-dz*lightCamera.sinPitch)
  if depth <= lightCamera.nearPlane or depth >= 15.99 then return 1.0 end if
  var factor as float=lightCamera.scale
  if lightCamera.perspective then factor=toFloat(factor*lightCamera.distance/depth) end if
  var x0 as int=math.floorInt(toNumber(lightCamera.centerX+rx*factor))
  var y0 as int=math.floorInt(toNumber(lightCamera.centerY-(ry*lightCamera.sinPitch+dz*lightCamera.cosPitch)*factor))
  var width as int=shadow.width
  if x0 < 0 or y0 < 0 or x0+1 >= width or y0+1 >= shadow.height then return 1.0 end if
  var expected as float=toFloat((depth-bias)*4096.0)
  var index as int=(y0*width+x0)*2
  var row as int=width*2
  var buffer as bytes=shadow.depth
  var visible as int=0
  if expected <= (buffer[index]|(buffer[index+1]<<8)) then visible=visible+1 end if
  if expected <= (buffer[index+2]|(buffer[index+3]<<8)) then visible=visible+1 end if
  index=index+row
  if expected <= (buffer[index]|(buffer[index+1]<<8)) then visible=visible+1 end if
  if expected <= (buffer[index+2]|(buffer[index+3]<<8)) then visible=visible+1 end if
  return toFloat(visible*0.25)
end function

/// Applies depth-map occlusion to the completed static receiver surface.
/// Reconstructs each visible world point from camera depth; receivers can be
/// vertical, sloping or elevated. Color and depth caches retain the result.
function applyShadowMap(s,c,shadow,lightCamera,strength=0.54,bias=0.002)
  var amount as float=toFloat(math.clamp(strength,0.0,1.0))
  var width as int=s.width
  var height as int=s.height
  var depths as bytes=s.depth
  var output as bytes=s.canvas.pixels
  var scale as float=c.scale
  var distance as float=c.distance
  var centerX as float=c.centerX; var centerY as float=c.centerY
  var targetX as float=c.targetX; var targetY as float=c.targetY; var targetZ as float=c.targetZ
  var sinPitch as float=c.sinPitch; var cosPitch as float=c.cosPitch
  var sinYaw as float=c.sinYaw; var cosYaw as float=c.cosYaw
  var perspective as bool=c.perspective
  var index as int=0; var pixel as int=0
  for y=0 to height-1
    for x=0 to width-1
      var encoded as int=depths[index]|(depths[index+1]<<8)
      if encoded < 65535 then
        var depth as float=toFloat(encoded/4096.0)
        var factor as float=scale
        if perspective then factor=toFloat(factor*distance/depth) end if
        var rx as float=toFloat((x+0.5-centerX)/factor)
        var vertical as float=toFloat((centerY-y-0.5)/factor)
        var delta as float=toFloat(depth-distance)
        var ry as float=toFloat(vertical*sinPitch+delta*cosPitch)
        var wz as float=toFloat(targetZ+vertical*cosPitch-delta*sinPitch)
        var wx as float=toFloat(targetX+rx*cosYaw+ry*sinYaw)
        var wy as float=toFloat(targetY-rx*sinYaw+ry*cosYaw)
        var visibility as float=shadowVisibility(shadow,lightCamera,wx,wy,wz,bias)
        if visibility < 1.0 then
          var shade as float=toFloat(1.0-amount*(1.0-visibility))
          output[pixel]=math.floorInt(toNumber(output[pixel]*shade))
          output[pixel+1]=math.floorInt(toNumber(output[pixel+1]*shade))
          output[pixel+2]=math.floorInt(toNumber(output[pixel+2]*shade))
        end if
      end if
      index=index+2; pixel=pixel+4
    end for
  end for
  cv.markDirty(s.canvas,0,0,width,height)
end function

/// Begins a non-accumulating dynamic shadow layer on a cached receiver image.
function shadowMask(s)
  return bytes(s.width*s.height,0)
end function

function _shadowSpan(s,mask as bytes,y as int,x0 as int,x1 as int,depth0 as float,depthStep as float,strength as float,perspective as bool)
  var depth as float=depth0
  var fade as float=toFloat(1.0-strength)
  var index as int=y*s.width+x0
  var di as int=index*2
  var pixel as int=index*4
  var buffer as bytes=s.depth
  var output as bytes=s.canvas.pixels
  for x=x0 to x1
    var actual as float=depth
    if perspective then actual=toFloat(1.0/depth) end if
    var encoded as int=math.floorInt(toNumber(actual*4096.0))
    var prior as int=buffer[di]|(buffer[di+1]<<8)
    if encoded >= 0 and encoded <= prior+1 and prior < 65535 and mask[index] == 0 then
      mask[index]=1
      output[pixel]=math.floorInt(toNumber(output[pixel]*fade))
      output[pixel+1]=math.floorInt(toNumber(output[pixel+1]*fade))
      output[pixel+2]=math.floorInt(toNumber(output[pixel+2]*fade))
    end if
    depth=toFloat(depth+depthStep)
    index=index+1; di=di+2; pixel=pixel+4
  end for
end function

function _shadowTriangle(s,mask,a,b,c,strength,perspective)
  if not a.visible or not b.visible or not c.visible then return end if
  if b.y < a.y then swap=a; a=b; b=swap end if
  if c.y < a.y then swap=a; a=c; c=swap end if
  if c.y < b.y then swap=b; b=c; c=swap end if
  totalHeight=c.y-a.y
  if totalHeight < 0.000001 then return end if
  first=math.max(0,math.ceilInt(a.y-0.5)); last=math.min(s.height-1,math.floorInt(c.y-0.5))
  if first > last then return end if
  da=a.depth; db=b.depth; dc=c.depth
  if perspective then da=1.0/da; db=1.0/db; dc=1.0/dc end if
  for y=first to last
    sampleY=y+0.5; longT=(sampleY-a.y)/totalHeight
    lx=a.x+(c.x-a.x)*longT; ld=da+(dc-da)*longT
    rx=0.0; rd=0.0
    if sampleY < b.y and b.y-a.y > 0.000001 then
      shortT=(sampleY-a.y)/(b.y-a.y)
      rx=a.x+(b.x-a.x)*shortT; rd=da+(db-da)*shortT
    else
      if c.y-b.y < 0.000001 then continue end if
      shortT=(sampleY-b.y)/(c.y-b.y)
      rx=b.x+(c.x-b.x)*shortT; rd=db+(dc-db)*shortT
    end if
    if lx > rx then swap=lx; lx=rx; rx=swap; swap=ld; ld=rd; rd=swap end if
    width=rx-lx
    if width > 0.000001 then
      start=math.max(0,math.ceilInt(lx-0.5)); finish=math.min(s.width-1,math.floorInt(rx-0.5))
      if start <= finish then
        step=(rd-ld)/width
        _shadowSpan(s,mask,y,start,finish,toFloat(ld+(start+0.5-lx)*step),toFloat(step),toFloat(strength),perspective)
      end if
    end if
  end for
end function

/// Projects the actual moving mesh silhouette along the directional light.
/// The receiver is one horizontal support plane; the live depth test prevents
/// the projection painting across objects in front of that plane.
function drawPlanarShadowAt(s,m,c,lights,mask,receiverZ,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0,strength=0.42)
  if m.count <= 0 or lights.z <= 0.00001 then return end if
  ca=math.cos(angle); sa=math.sin(angle)
  for i=0 to m.count-1
    t=m.triangles[i]
    ax=0.0; ay=0.0; az=0.0; bx=0.0; by=0.0; bz=0.0; cx=0.0; cy=0.0; cz=0.0
    if t is TexturedTriangle then
      ax=t.a.x; ay=t.a.y; az=t.a.z; bx=t.b.x; by=t.b.y; bz=t.b.z; cx=t.c.x; cy=t.c.y; cz=t.c.z
    else
      ax=t.ax; ay=t.ay; az=t.az; bx=t.bx; by=t.by; bz=t.bz; cx=t.cx; cy=t.cy; cz=t.cz
    end if
    wx=ax*sx*ca-ay*sy*sa+tx; wy=ax*sx*sa+ay*sy*ca+ty; ax=wx; ay=wy; az=az*sz+tz
    wx=bx*sx*ca-by*sy*sa+tx; wy=bx*sx*sa+by*sy*ca+ty; bx=wx; by=wy; bz=bz*sz+tz
    wx=cx*sx*ca-cy*sy*sa+tx; wy=cx*sx*sa+cy*sy*ca+ty; cx=wx; cy=wy; cz=cz*sz+tz
    ux=bx-ax; uy=by-ay; uz=bz-az; vx=cx-ax; vy=cy-ay; vz=cz-az
    facing=(uy*vz-uz*vy)*lights.x+(uz*vx-ux*vz)*lights.y+(ux*vy-uy*vx)*lights.z
    // Closed caster silhouettes are fully covered by their source-facing skin.
    if facing <= 0.0 then continue end if
    da=math.max(0.0,az-receiverZ)/lights.z
    db=math.max(0.0,bz-receiverZ)/lights.z
    dc=math.max(0.0,cz-receiverZ)/lights.z
    a=project(c,ax-lights.x*da,ay-lights.y*da,receiverZ)
    b=project(c,bx-lights.x*db,by-lights.y*db,receiverZ)
    d=project(c,cx-lights.x*dc,cy-lights.y*dc,receiverZ)
    _shadowTriangle(s,mask,a,b,d,strength,c.perspective)
  end for
end function

/// Projects one world position into pixel coordinates and camera depth.
function project(c, x, y, z)
  var dx as float = toFloat(x - c.targetX)
  var dy as float = toFloat(y - c.targetY)
  var dz as float = toFloat(z - c.targetZ)
  var rx as float = toFloat(dx*c.cosYaw - dy*c.sinYaw)
  var ry as float = toFloat(dx*c.sinYaw + dy*c.cosYaw)
  var depth as float = toFloat(c.distance + ry*c.cosPitch - dz*c.sinPitch)
  if depth <= c.nearPlane or depth >= 15.99 then return Projected(0.0,0.0,depth,false) end if
  var factor as float = c.scale
  if c.perspective then factor = toFloat(factor*c.distance/depth) end if
  return Projected(toFloat(c.centerX + rx*factor),toFloat(c.centerY - (ry*c.sinPitch + dz*c.cosPitch)*factor),depth,true)
end function

/// Wraps a Canvas with a fresh depth buffer; each depth unit is 1/4096 world unit.
function surface(canvas)
  return Surface(canvas,bytes(canvas.width*canvas.height*2,255),canvas.width,canvas.height,0)
end function

/// Clears color and depth together.
function clear(s, color)
  s.canvas.clear(color)
  s.depth = bytes(s.width*s.height*2,255)
  s.triangles = 0
end function

/// Copies an immutable scene cache including its exact per-pixel depth.
function copySurface(destination, source)
  if destination.width != source.width or destination.height != source.height then return false end if
  copyBytes(destination.canvas.pixels,0,source.canvas.pixels,0,len(source.canvas.pixels))
  copyBytes(destination.depth,0,source.depth,0,len(source.depth))
  destination.canvas.imageView.opaque = source.canvas.imageView.opaque
  destination.canvas.dirty = true
  destination.canvas.dirtyX0 = 0
  destination.canvas.dirtyY0 = 0
  destination.canvas.dirtyX1 = destination.width
  destination.canvas.dirtyY1 = destination.height
  destination.triangles = 0
  return true
end function

/// Allocates a growable triangle mesh.
function mesh(capacity=256)
  if capacity < 1 then capacity = 1 end if
  return Mesh(array(capacity),0,capacity,array(capacity),array(capacity))
end function

/// Scales RGB while retaining opaque output.
function colorScale(color as int, factor) returns int
  var red as int = math.floorInt(toNumber(((color >> 24)&255)*factor))
  var green as int = math.floorInt(toNumber(((color >> 16)&255)*factor))
  var blue as int = math.floorInt(toNumber(((color >> 8)&255)*factor))
  if red > 255 then red = 255 end if
  if green > 255 then green = 255 end if
  if blue > 255 then blue = 255 end if
  if red < 0 then red = 0 end if
  if green < 0 then green = 0 end if
  if blue < 0 then blue = 0 end if
  return (red << 24)|(green << 16)|(blue << 8)|255
end function

/// Appends a flat-shaded triangle. Winding determines its light-facing normal.
function triangle(m, ax,ay,az,bx,by,bz,cx,cy,cz,color,lit=true)
  if m.count >= m.capacity then
    next = array(m.capacity*2)
    copyArray(next,0,m.triangles,0,m.count)
    m.triangles = next
    nextAlbedo = array(m.capacity*2); copyArray(nextAlbedo,0,m.albedo,0,m.count); m.albedo = nextAlbedo
    nextLighting = array(m.capacity*2); copyArray(nextLighting,0,m.lighting,0,m.count); m.lighting = nextLighting
    m.capacity = m.capacity*2
  end if
  m.albedo[m.count] = color
  m.lighting[m.count] = lit
  if lit then
    ux = bx-ax
    uy = by-ay
    uz = bz-az
    vx = cx-ax
    vy = cy-ay
    vz = cz-az
    nx = uy*vz-uz*vy
    ny = uz*vx-ux*vz
    nz = ux*vy-uy*vx
    magnitude = math.sqrt(nx*nx+ny*ny+nz*nz)
    light = 0.0
    if magnitude > 0.000000001 then light = (nx*(-0.34)+ny*(-0.42)+nz*0.84)/magnitude end if
    if light < 0.0 then light = 0.0 end if
    color = colorScale(color,0.38+0.62*light)
  end if
  m.triangles[m.count] = Triangle(toFloat(ax),toFloat(ay),toFloat(az),toFloat(bx),toFloat(by),toFloat(bz),toFloat(cx),toFloat(cy),toFloat(cz),color)
  m.count = m.count+1
end function

/// Appends a quad using two triangles.
function quad(m,a,b,c,d,color,lit=true)
  triangle(m,a.x,a.y,a.z,b.x,b.y,b.z,c.x,c.y,c.z,color,lit)
  triangle(m,a.x,a.y,a.z,c.x,c.y,c.z,d.x,d.y,d.z,color,lit)
end function

/// Creates a clamped RGBA texture material sharing a MiniPixels Image buffer.
/// Alpha is a coverage cutout; surviving pixels are opaque. Tint affects RGB.
/// Keep the source image immutable; recreate the material after pixel changes.
function texture(image,tint=0xffffffff,alphaCutoff=128,bilinear=true)
  if not (image is g3image.Image) then return error(8301,"geometry3d texture requires an Image") end if
  if image.width <= 0 or image.height <= 0 or len(image.pixels) != image.width*image.height*4 then return error(8302,"geometry3d texture dimensions are invalid") end if
  if alphaCutoff < 1 then alphaCutoff = 1 end if
  if alphaCutoff > 255 then alphaCutoff = 255 end if
  return Texture(image.width,image.height,image.pixels,image.opaque,tint,alphaCutoff,bilinear)
end function

/// Creates a tiled texture for UVs expressed in world-sized repeats.
function repeatingTexture(image,tint=0xffffffff,alphaCutoff=128,bilinear=true)
  base=texture(image,tint,alphaCutoff,bilinear)
  return RepeatingTexture(base.width,base.height,base.pixels,base.opaque,base.tint,base.alphaCutoff,base.bilinear)
end function

/// Appends a textured triangle with independent normalized UV coordinates.
function texturedTriangle(m,a,b,c,uvA,uvB,uvC,material,lit=false)
  if not (material is Texture) and not (material is RepeatingTexture) then return false end if
  if m.count >= m.capacity then
    next = array(m.capacity*2)
    copyArray(next,0,m.triangles,0,m.count)
    m.triangles = next
    nextAlbedo = array(m.capacity*2); copyArray(nextAlbedo,0,m.albedo,0,m.count); m.albedo = nextAlbedo
    nextLighting = array(m.capacity*2); copyArray(nextLighting,0,m.lighting,0,m.count); m.lighting = nextLighting
    m.capacity = m.capacity*2
  end if
  color = material.tint
  m.albedo[m.count] = color
  m.lighting[m.count] = lit
  if lit then
    ux = b.x-a.x; uy = b.y-a.y; uz = b.z-a.z
    vx = c.x-a.x; vy = c.y-a.y; vz = c.z-a.z
    nx = uy*vz-uz*vy; ny = uz*vx-ux*vz; nz = ux*vy-uy*vx
    magnitude = math.sqrt(nx*nx+ny*ny+nz*nz)
    light = 0.0
    if magnitude > 0.000000001 then light = math.max(0.0,(nx*(-0.34)+ny*(-0.42)+nz*0.84)/magnitude) end if
    color = colorScale(color,0.38+0.62*light)
  end if
  m.triangles[m.count] = TexturedTriangle(Point(a.x,a.y,a.z),Point(b.x,b.y,b.z),Point(c.x,c.y,c.z),UV(uvA.u,uvA.v),UV(uvB.u,uvB.v),UV(uvC.u,uvC.v),material,color)
  m.count = m.count+1
  return true
end function

/// Maps an image onto a quad. Default vertex order is bottom-left,
/// bottom-right, top-right, top-left; image V=0 is its top edge.
/// Custom UV arrays also allow atlas cells and diamond-shaped source regions.
function texturedQuad(m,a,b,c,d,material,uvs=void,lit=false)
  if typeof(uvs) == "void" then uvs = [UV(0.0,1.0),UV(1.0,1.0),UV(1.0,0.0),UV(0.0,0.0)] end if
  if typeof(uvs) != "array" or len(uvs) != 4 then return false end if
  if not texturedTriangle(m,a,b,c,uvs[0],uvs[1],uvs[2],material,lit) then return false end if
  return texturedTriangle(m,a,c,d,uvs[0],uvs[2],uvs[3],material,lit)
end function

/// Samples a clamped texture. Bilinear RGBA filtering uses premultiplied color
/// internally so transparent white/black borders do not create colored halos.
function sampleTexture(material,u,v)
  if material is RepeatingTexture then
    u=u-math.floor(u); v=v-math.floor(v)
  else
    u = math.clamp(u,0.0,1.0)
    v = math.clamp(v,0.0,1.0)
  end if
  var fx as float = toFloat(u*(material.width-1))
  var fy as float = toFloat(v*(material.height-1))
  pixels = material.pixels
  if not material.bilinear then
    x = math.floorInt(toNumber(fx+0.5))
    y = math.floorInt(toNumber(fy+0.5))
    index = (y*material.width+x)*4
    return (pixels[index]<<24)|(pixels[index+1]<<16)|(pixels[index+2]<<8)|pixels[index+3]
  end if
  var x0 as int = math.floorInt(toNumber(fx))
  var y0 as int = math.floorInt(toNumber(fy))
  x1 = math.min(x0+1,material.width-1)
  y1 = math.min(y0+1,material.height-1)
  var dx as float = toFloat(fx-x0)
  var dy as float = toFloat(fy-y0)
  var w0 as float = toFloat((1.0-dx)*(1.0-dy))
  var w1 as float = toFloat(dx*(1.0-dy))
  var w2 as float = toFloat((1.0-dx)*dy)
  var w3 as float = toFloat(dx*dy)
  i0 = (y0*material.width+x0)*4
  i1 = (y0*material.width+x1)*4
  i2 = (y1*material.width+x0)*4
  i3 = (y1*material.width+x1)*4
  alpha = 255
  var divisor as float = 1.0
  if not material.opaque then
    w0 = toFloat(w0*pixels[i0+3])
    w1 = toFloat(w1*pixels[i1+3])
    w2 = toFloat(w2*pixels[i2+3])
    w3 = toFloat(w3*pixels[i3+3])
    divisor = toFloat(w0+w1+w2+w3)
    if divisor <= 0.000001 then return 0 end if
    alpha = math.floorInt(toNumber(divisor+0.5))
  end if
  red = math.floorInt(toNumber((pixels[i0]*w0+pixels[i1]*w1+pixels[i2]*w2+pixels[i3]*w3)/divisor+0.5))
  green = math.floorInt(toNumber((pixels[i0+1]*w0+pixels[i1+1]*w1+pixels[i2+1]*w2+pixels[i3+1]*w3)/divisor+0.5))
  blue = math.floorInt(toNumber((pixels[i0+2]*w0+pixels[i1+2]*w1+pixels[i2+2]*w2+pixels[i3+2]*w3)/divisor+0.5))
  return (red<<24)|(green<<16)|(blue<<8)|alpha
end function

/// Appends an axis-aligned closed box; x/y are its center and z its base.
function box(m,x,y,z,sx,sy,sz,color)
  a = Point(x-sx*0.5,y-sy*0.5,z)
  b = Point(x+sx*0.5,y-sy*0.5,z)
  c = Point(x+sx*0.5,y+sy*0.5,z)
  d = Point(x-sx*0.5,y+sy*0.5,z)
  e = Point(a.x,a.y,z+sz)
  f = Point(b.x,b.y,z+sz)
  g = Point(c.x,c.y,z+sz)
  h = Point(d.x,d.y,z+sz)
  quad(m,e,f,g,h,color)
  quad(m,a,b,f,e,color)
  quad(m,b,c,g,f,color)
  quad(m,c,d,h,g,color)
  quad(m,d,a,e,h,color)
  quad(m,d,c,b,a,color)
end function

/// Appends a sloping rectangular beam between two base-center positions.
function beam(m,ax,ay,az,bx,by,bz,width,height,color)
  dx = bx-ax
  dy = by-ay
  length = math.sqrt(dx*dx+dy*dy)
  if length < 0.000001 then
    box(m,ax,ay,az,width,width,height,color)
    return
  end if
  px = (0-dy)*width*0.5/length
  py = dx*width*0.5/length
  a = Point(ax-px,ay-py,az)
  b = Point(bx-px,by-py,bz)
  c = Point(bx+px,by+py,bz)
  d = Point(ax+px,ay+py,az)
  e = Point(a.x,a.y,a.z+height)
  f = Point(b.x,b.y,b.z+height)
  g = Point(c.x,c.y,c.z+height)
  h = Point(d.x,d.y,d.z+height)
  quad(m,e,f,g,h,color)
  quad(m,a,b,f,e,color)
  quad(m,b,c,g,f,color)
  quad(m,c,d,h,g,color)
  quad(m,d,a,e,h,color)
end function

/// Appends a capped vertical polygonal cylinder.
function cylinder(m,x,y,z,radius,height,color,sides=16)
  for i = 0 to sides-1
    a0 = i*math.tau()/sides
    a1 = (i+1)*math.tau()/sides
    ax = x+math.cos(a0)*radius
    ay = y+math.sin(a0)*radius
    bx = x+math.cos(a1)*radius
    by = y+math.sin(a1)*radius
    triangle(m,x,y,z+height,ax,ay,z+height,bx,by,z+height,color)
    triangle(m,ax,ay,z,bx,by,z,bx,by,z+height,color)
    triangle(m,ax,ay,z,bx,by,z+height,ax,ay,z+height,color)
    triangle(m,x,y,z,bx,by,z,ax,ay,z,color)
  end for
end function

/// Appends a unit sphere centered on the origin; gloss is a baked light highlight.
function sphere(m,color,slices=20,rings=12,gloss=true)
  for row = 0 to rings-1
    p0 = (-math.pi()*0.5)+row*math.pi()/rings
    p1 = (-math.pi()*0.5)+(row+1)*math.pi()/rings
    for col = 0 to slices-1
      a0 = col*math.tau()/slices
      a1 = (col+1)*math.tau()/slices
      a = Point(math.cos(p0)*math.cos(a0),math.cos(p0)*math.sin(a0),math.sin(p0))
      b = Point(math.cos(p0)*math.cos(a1),math.cos(p0)*math.sin(a1),math.sin(p0))
      c = Point(math.cos(p1)*math.cos(a1),math.cos(p1)*math.sin(a1),math.sin(p1))
      d = Point(math.cos(p1)*math.cos(a0),math.cos(p1)*math.sin(a0),math.sin(p1))
      material = color
      if gloss then
        nx = (a.x+b.x+c.x+d.x)*0.25
        ny = (a.y+b.y+c.y+d.y)*0.25
        nz = (a.z+b.z+c.z+d.z)*0.25
        highlight = nx*(-0.30)+ny*(-0.50)+nz*0.81
        if highlight > 0.83 then material = 0xf7f8f2ff end if
        if highlight < 0.15 and nz > -0.15 then material = 0x829fa4ff end if
      end if
      quad(m,a,b,c,d,material)
    end for
  end for
end function

/// Rasterizes one depth-tested scanline, emitting contiguous visible Canvas spans.
function rasterSpan(s,y as int,x0 as int,x1 as int,depth0 as float,depthStep as float,color as int,perspective as bool)
  var index as int = (y*s.width+x0)*2
  var run as int = -1
  var depth as float = depth0
  for x = x0 to x1
    var actual as float = toFloat(depth)
    if perspective then actual = toFloat(1.0/depth) end if
    var encoded as int = math.floorInt(toNumber(actual*4096.0))
    var prior as int = s.depth[index] | (s.depth[index+1] << 8)
    if encoded >= 0 and encoded < 65535 and encoded <= prior then
      s.depth[index] = encoded & 255
      s.depth[index+1] = (encoded >> 8)&255
      if run < 0 then run = x end if
    else
      if run >= 0 then
        cv.fillRect(s.canvas,run,y,x-run,1,color)
        run = -1
      end if
    end if
    depth = toFloat(depth+depthStep)
    index = index+2
  end for
  if run >= 0 then cv.fillRect(s.canvas,run,y,x1-run+1,1,color) end if
end function

/// Draws a projected opaque triangle with pixel-center coverage.
function rasterTriangle(s,a,b,c,color,perspective)
  if not a.visible or not b.visible or not c.visible then return end if
  if b.y < a.y then swap = a; a = b; b = swap end if
  if c.y < a.y then swap = a; a = c; c = swap end if
  if c.y < b.y then swap = b; b = c; c = swap end if
  var totalHeight as float = toFloat(c.y-a.y)
  if totalHeight < 0.000001 then return end if
  var first as int = math.ceilInt(toNumber(a.y-0.5))
  var last as int = math.floorInt(toNumber(c.y-0.5))
  if first < 0 then first = 0 end if
  if last >= s.height then last = s.height-1 end if
  if first > last then return end if
  var da as float = toFloat(a.depth)
  var db as float = toFloat(b.depth)
  var dc as float = toFloat(c.depth)
  if perspective then da = toFloat(1.0/da); db = toFloat(1.0/db); dc = toFloat(1.0/dc) end if
  for y = first to last
    var sampleY as float = y+0.5
    var longT as float = toFloat((sampleY-a.y)/totalHeight)
    var lx as float = toFloat(a.x+(c.x-a.x)*longT)
    var ld as float = toFloat(da+(dc-da)*longT)
    var rx as float = 0.0
    var rd as float = 0.0
    if sampleY < b.y and b.y-a.y > 0.000001 then
      shortT = (sampleY-a.y)/(b.y-a.y)
      rx = toFloat(a.x+(b.x-a.x)*shortT)
      rd = toFloat(da+(db-da)*shortT)
    else
      if c.y-b.y < 0.000001 then continue end if
      shortT = (sampleY-b.y)/(c.y-b.y)
      rx = toFloat(b.x+(c.x-b.x)*shortT)
      rd = toFloat(db+(dc-db)*shortT)
    end if
    if lx > rx then
      swapX = lx; lx = rx; rx = swapX
      swapD = ld; ld = rd; rd = swapD
    end if
    var spanWidth as float = toFloat(rx-lx)
    if spanWidth > 0.000001 then
      var start as int = math.ceilInt(toNumber(lx-0.5))
      var finish as int = math.floorInt(toNumber(rx-0.5))
      if start < 0 then start = 0 end if
      if finish >= s.width then finish = s.width-1 end if
      if start <= finish then
        var step as float = toFloat((rd-ld)/spanWidth)
        rasterSpan(s,y,start,finish,toFloat(ld+(start+0.5-lx)*step),step,color,perspective)
      end if
    end if
  end for
  s.triangles = s.triangles+1
end function

/// Draws a textured span. Transparent texels never modify color or depth.
function rasterTextureSpan(s,y as int,x0 as int,x1 as int,depth0 as float,depthStep as float,u0 as float,uStep as float,v0 as float,vStep as float,material,color as int,perspective as bool)
  var depth as float = depth0
  var currentU as float = u0
  var currentV as float = v0
  var depthIndex as int = (y*s.width+x0)*2
  var pixelIndex as int = (y*s.width+x0)*4
  output = s.canvas.pixels
  depthBuffer = s.depth
  tintRed = (color>>24)&255
  tintGreen = (color>>16)&255
  tintBlue = (color>>8)&255
  tinted = color != 0xffffffff
  for x = x0 to x1
    var actualDepth as float = toFloat(depth)
    var u as float = toFloat(currentU)
    var v as float = toFloat(currentV)
    if perspective then
      actualDepth = toFloat(1.0/depth)
      u = toFloat(currentU*actualDepth)
      v = toFloat(currentV*actualDepth)
    end if
    encoded = math.floorInt(toNumber(actualDepth*4096.0))
    prior = depthBuffer[depthIndex]|(depthBuffer[depthIndex+1]<<8)
    if encoded >= 0 and encoded < 65535 and encoded <= prior then
      sampled = sampleTexture(material,u,v)
      alpha = sampled&255
      if alpha >= material.alphaCutoff then
        red = (sampled>>24)&255
        green = (sampled>>16)&255
        blue = (sampled>>8)&255
        if tinted then
          value = red*tintRed; red = (value+1+(value>>8))>>8
          value = green*tintGreen; green = (value+1+(value>>8))>>8
          value = blue*tintBlue; blue = (value+1+(value>>8))>>8
        end if
        output[pixelIndex] = red
        output[pixelIndex+1] = green
        output[pixelIndex+2] = blue
        output[pixelIndex+3] = 255
        depthBuffer[depthIndex] = encoded&255
        depthBuffer[depthIndex+1] = (encoded>>8)&255
      end if
    end if
    depth = toFloat(depth+depthStep)
    currentU = toFloat(currentU+uStep)
    currentV = toFloat(currentV+vStep)
    depthIndex = depthIndex+2
    pixelIndex = pixelIndex+4
  end for
end function

/// Rasterizes a UV triangle with inverse-depth attributes in perspective mode.
function rasterTexturedTriangle(s,a,b,c,uvA,uvB,uvC,material,color,perspective)
  if not a.visible or not b.visible or not c.visible then return end if
  if b.y < a.y then swap=a; a=b; b=swap; uvSwap=uvA; uvA=uvB; uvB=uvSwap end if
  if c.y < a.y then swap=a; a=c; c=swap; uvSwap=uvA; uvA=uvC; uvC=uvSwap end if
  if c.y < b.y then swap=b; b=c; c=swap; uvSwap=uvB; uvB=uvC; uvC=uvSwap end if
  var totalHeight as float = toFloat(c.y-a.y)
  if totalHeight < 0.000001 then return end if
  first = math.max(0,math.ceilInt(toNumber(a.y-0.5)))
  last = math.min(s.height-1,math.floorInt(toNumber(c.y-0.5)))
  if first > last then return end if
  var da as float = toFloat(a.depth)
  var db as float = toFloat(b.depth)
  var dc as float = toFloat(c.depth)
  var ua as float = toFloat(uvA.u)
  var ub as float = toFloat(uvB.u)
  var uc as float = toFloat(uvC.u)
  var va as float = toFloat(uvA.v)
  var vb as float = toFloat(uvB.v)
  var vc as float = toFloat(uvC.v)
  if perspective then
    da=toFloat(1.0/da); db=toFloat(1.0/db); dc=toFloat(1.0/dc)
    ua=toFloat(ua*da); ub=toFloat(ub*db); uc=toFloat(uc*dc)
    va=toFloat(va*da); vb=toFloat(vb*db); vc=toFloat(vc*dc)
  end if
  minimumX = s.width
  maximumX = -1
  for y = first to last
    sampleY = y+0.5
    longT = (sampleY-a.y)/totalHeight
    var lx as float = toFloat(a.x+(c.x-a.x)*longT)
    var ld as float = toFloat(da+(dc-da)*longT)
    var lu as float = toFloat(ua+(uc-ua)*longT)
    var lv as float = toFloat(va+(vc-va)*longT)
    var rx as float = 0.0
    var rd as float = 0.0
    var ru as float = 0.0
    var rv as float = 0.0
    if sampleY < b.y and b.y-a.y > 0.000001 then
      shortT = (sampleY-a.y)/(b.y-a.y)
      rx=toFloat(a.x+(b.x-a.x)*shortT); rd=toFloat(da+(db-da)*shortT)
      ru=toFloat(ua+(ub-ua)*shortT); rv=toFloat(va+(vb-va)*shortT)
    else
      if c.y-b.y < 0.000001 then continue end if
      shortT = (sampleY-b.y)/(c.y-b.y)
      rx=toFloat(b.x+(c.x-b.x)*shortT); rd=toFloat(db+(dc-db)*shortT)
      ru=toFloat(ub+(uc-ub)*shortT); rv=toFloat(vb+(vc-vb)*shortT)
    end if
    if lx > rx then
      swapX=lx; lx=rx; rx=swapX
      swapD=ld; ld=rd; rd=swapD
      swapU=lu; lu=ru; ru=swapU
      swapV=lv; lv=rv; rv=swapV
    end if
    var width as float = toFloat(rx-lx)
    if width > 0.000001 then
      start = math.max(0,math.ceilInt(toNumber(lx-0.5)))
      finish = math.min(s.width-1,math.floorInt(toNumber(rx-0.5)))
      if start <= finish then
        var dd as float = toFloat((rd-ld)/width)
        var du as float = toFloat((ru-lu)/width)
        var dv as float = toFloat((rv-lv)/width)
        offset = start+0.5-lx
        rasterTextureSpan(s,y,start,finish,toFloat(ld+offset*dd),dd,toFloat(lu+offset*du),du,toFloat(lv+offset*dv),dv,material,color,perspective)
        if start < minimumX then minimumX = start end if
        if finish > maximumX then maximumX = finish end if
      end if
    end if
  end for
  if maximumX >= minimumX then
    cv.markDirty(s.canvas,minimumX,first,maximumX-minimumX+1,last-first+1)
    s.canvas.drawCalls = s.canvas.drawCalls+1
  end if
  s.triangles = s.triangles+1
end function

/// Draws a resident mesh with translation, rotation around Z and axis scales.
function drawAt(s,m,c,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0)
  if m.count <= 0 then return end if
  ca = math.cos(angle)
  sa = math.sin(angle)
  for i = 0 to m.count-1
    t = m.triangles[i]
    if t is TexturedTriangle then
      a = project(c,tx+t.a.x*sx*ca-t.a.y*sy*sa,ty+t.a.x*sx*sa+t.a.y*sy*ca,tz+t.a.z*sz)
      b = project(c,tx+t.b.x*sx*ca-t.b.y*sy*sa,ty+t.b.x*sx*sa+t.b.y*sy*ca,tz+t.b.z*sz)
      d = project(c,tx+t.c.x*sx*ca-t.c.y*sy*sa,ty+t.c.x*sx*sa+t.c.y*sy*ca,tz+t.c.z*sz)
      rasterTexturedTriangle(s,a,b,d,t.uvA,t.uvB,t.uvC,t.material,t.color,c.perspective)
    else
      a = project(c,tx+t.ax*sx*ca-t.ay*sy*sa,ty+t.ax*sx*sa+t.ay*sy*ca,tz+t.az*sz)
      b = project(c,tx+t.bx*sx*ca-t.by*sy*sa,ty+t.bx*sx*sa+t.by*sy*ca,tz+t.bz*sz)
      d = project(c,tx+t.cx*sx*ca-t.cy*sy*sa,ty+t.cx*sx*sa+t.cy*sy*ca,tz+t.cz*sz)
      rasterTriangle(s,a,b,d,t.color,c.perspective)
    end if
  end for
end function
