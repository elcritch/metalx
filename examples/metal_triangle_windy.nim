import std/importutils
import darwin/objc/runtime
import darwin/app_kit/[nsview, nswindow]
import darwin/foundation/nsgeometry
import darwin/foundation/[nserror, nsstring]
import metalx/[cametal, metal]
import windy

when not defined(macosx):
  {.error: "This example requires macOS.".}

privateAccess(Window)

let window = newWindow("Metal Triangle (Windy)", ivec2(1280, 800))

let cocoaWindow: NSWindow = cast[NSWindow](cast[pointer](window.inner.int))
let existingView = cocoaWindow.contentView()
let metalHostView = NSView.alloc().initWithFrame(existingView.bounds())
metalHostView.setAutoresizingMask(
  NSAutoresizingMaskOptions(NSViewWidthSizable.ord or NSViewHeightSizable.ord)
)
metalHostView.setWantsLayer(true)
existingView.addSubview(metalHostView)

let device = MTLCreateSystemDefaultDevice()
if device.isNil:
  quit "Metal device not available"

let metalLayer = CAMetalLayer.alloc().init()
metalLayer.setDevice(device)
metalLayer.setPixelFormat(MTLPixelFormatBGRA8Unorm)
metalLayer.setDrawableSize(
  NSSize(width: window.size.x.float, height: window.size.y.float)
)
metalLayer.setFrame(metalHostView.bounds())
metalHostView.setLayer(metalLayer)
echo "Metal layer set up: pixelFormat=",
  metalLayer.pixelFormat().uint,
  " drawableSize=",
  metalLayer.drawableSize().width,
  "x",
  metalLayer.drawableSize().height

let shaderSource =
  """
#include <metal_stdlib>
using namespace metal;

struct VSOut {
  float4 position [[position]];
  float4 color;
};

vertex VSOut vs_main(uint vid [[vertex_id]],
                     const device float2* positions [[buffer(0)]]) {
  VSOut out;
  float2 p = positions[vid];
  out.position = float4(p.x, p.y, 0.0, 1.0);
  out.color = float4(1.0, 0.5, p.x, 1.0);
  return out;
}

fragment float4 fs_main(VSOut in [[stage_in]]) {
  return in.color;
}
"""

var error: NSError
let library = newLibraryWithSource(
  device,
  NSString.withUTF8String(cstring(shaderSource)),
  MTLCompileOptions(nil),
  addr error,
)
if library.isNil:
  echo error
  quit "Failed to compile Metal shaders"
else:
  echo "Compiled Metal library"

let vertexFunction =
  newFunctionWithName(library, NSString.withUTF8String(cstring("vs_main")))
let fragmentFunction =
  newFunctionWithName(library, NSString.withUTF8String(cstring("fs_main")))
if vertexFunction.isNil or fragmentFunction.isNil:
  quit "Failed to find Metal shader functions"
else:
  echo "Shader functions loaded"

let pipelineDescriptor = MTLRenderPipelineDescriptor.alloc().init()
setVertexFunction(pipelineDescriptor, vertexFunction)
setFragmentFunction(pipelineDescriptor, fragmentFunction)

let pipelineColor = objectAtIndexedSubscript(colorAttachments(pipelineDescriptor), 0)
setPixelFormat(pipelineColor, metalLayer.pixelFormat())

let pipelineState =
  newRenderPipelineStateWithDescriptor(device, pipelineDescriptor, addr error)
if pipelineState.isNil:
  echo error
  quit "Failed to create pipeline state"
else:
  echo "Pipeline state created"

let vertices: array[6, float32] =
  [-0.6'f32, -0.6'f32, 0.6'f32, -0.6'f32, 0.0'f32, 0.6'f32]

let vertexBuffer = newBufferWithBytes(
  device,
  vertices[0].addr,
  NSUInteger(vertices.len * sizeof(float32)),
  MTLResourceOptions(0),
)
if vertexBuffer.isNil:
  quit "Failed to create vertex buffer"
else:
  echo "Vertex buffer created"

let queue = newCommandQueue(device)
if queue.isNil:
  quit "Failed to create command queue"
else:
  echo "Command queue created"

var frameIndex = 0

proc drawFrame() =
  let drawable = metalLayer.nextDrawable()
  if drawable.isNil:
    echo "Drawable is nil"
    return

  let passDescriptor = MTLRenderPassDescriptor.renderPassDescriptor()
  if passDescriptor.isNil:
    echo "Render pass descriptor is nil"
    return
  let colorAttachment = objectAtIndexedSubscript(colorAttachments(passDescriptor), 0)
  if colorAttachment.isNil:
    echo "Color attachment is nil"
    return
  setTexture(colorAttachment, texture(drawable))
  setLoadAction(colorAttachment, MTLLoadActionClear)
  setStoreAction(colorAttachment, MTLStoreActionStore)
  setClearColor(
    colorAttachment, MTLClearColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
  )

  let buffer = commandBuffer(queue)
  if buffer.isNil:
    echo "Command buffer is nil"
    return
  let encoder = renderCommandEncoderWithDescriptor(buffer, passDescriptor)
  if encoder.isNil:
    echo "Encoder is nil"
    return
  setRenderPipelineState(encoder, pipelineState)
  setVertexBuffer(encoder, vertexBuffer, 0, 0)
  drawPrimitives(encoder, MTLPrimitiveType(3), 0, 3)
  endEncoding(encoder)
  presentDrawable(buffer, cast[MTLDrawable](drawable))
  commit(buffer)
  if frameIndex == 0:
    echo "First frame submitted"
  inc frameIndex

while not window.closeRequested:
  metalLayer.setFrame(metalHostView.bounds())
  metalLayer.setDrawableSize(
    NSSize(width: window.size.x.float, height: window.size.y.float)
  )
  drawFrame()
  pollEvents()
