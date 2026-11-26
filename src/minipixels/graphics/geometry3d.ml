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
  return Mesh(array(capacity),0,capacity)
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
    m.capacity = m.capacity*2
  end if
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

/// Appends a textured triangle with independent normalized UV coordinates.
function texturedTriangle(m,a,b,c,uvA,uvB,uvC,material,lit=false)
  if not (material is Texture) then return false end if
  if m.count >= m.capacity then
    next = array(m.capacity*2)
    copyArray(next,0,m.triangles,0,m.count)
    m.triangles = next
    m.capacity = m.capacity*2
  end if
  color = material.tint
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
  u = math.clamp(u,0.0,1.0)
  v = math.clamp(v,0.0,1.0)
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
