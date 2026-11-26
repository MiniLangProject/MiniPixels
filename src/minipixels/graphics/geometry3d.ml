// SPDX-License-Identifier: Apache-2.0
//! Portable CPU 3D geometry for a MiniPixels Canvas. Flat shaded triangles use
//! a 16-bit depth buffer and perspective-correct inverse-depth interpolation.
//! Geometry crossing the near plane is rejected, not clipped; choose a camera
//! that keeps the complete scene in front of it. No textures or transparency.
package minipixels.graphics.geometry3d

import minipixels.graphics.canvas as cv
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
  destination.canvas.imageView.opaque = true
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

/// Draws a resident mesh with translation, rotation around Z and axis scales.
function drawAt(s,m,c,tx=0.0,ty=0.0,tz=0.0,angle=0.0,sx=1.0,sy=1.0,sz=1.0)
  if m.count <= 0 then return end if
  ca = math.cos(angle)
  sa = math.sin(angle)
  for i = 0 to m.count-1
    t = m.triangles[i]
    a = project(c,tx+t.ax*sx*ca-t.ay*sy*sa,ty+t.ax*sx*sa+t.ay*sy*ca,tz+t.az*sz)
    b = project(c,tx+t.bx*sx*ca-t.by*sy*sa,ty+t.bx*sx*sa+t.by*sy*ca,tz+t.bz*sz)
    d = project(c,tx+t.cx*sx*ca-t.cy*sy*sa,ty+t.cx*sx*sa+t.cy*sy*ca,tz+t.cz*sz)
    rasterTriangle(s,a,b,d,t.color,c.perspective)
  end for
end function
