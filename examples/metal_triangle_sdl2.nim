import darwin/objc/runtime
import darwin/core_graphics/cggeometry
import darwin/foundation/[nserror, nsstring]
import metalx/[cametal, metal, sdl2shim]

when not defined(macosx):
  {.error: "This example requires macOS.".}


discard setHint(SDL_HINT_RENDER_DRIVER, "metal")
if init(INIT_VIDEO) != SdlSuccess:
  quit "SDL_Init failed"

let window = createWindow(
  "Metal Triangle (SDL2)",
  SDL_WINDOWPOS_CENTERED,
  SDL_WINDOWPOS_CENTERED,
  1280,
  800,
  SDL_WINDOW_ALLOW_HIGHDPI or SDL_WINDOW_RESIZABLE,
)
if window.isNil:
  quit "SDL_CreateWindow failed"

let renderer = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync)
if renderer.isNil:
  quit "SDL_CreateRenderer failed"

let layerPtr = renderGetMetalLayer(renderer)
if layerPtr.isNil:
  quit "SDL_RenderGetMetalLayer failed"

let metalLayer = cast[CAMetalLayer](layerPtr)
metalLayer.setPixelFormat(MTLPixelFormatBGRA8Unorm)

var device = metalLayer.device()
if device.isNil:
  device = MTLCreateSystemDefaultDevice()
  if device.isNil:
    quit "Metal device not available"
  metalLayer.setDevice(device)

var error: NSError
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

let library = newLibraryWithSource(
  device,
  NSString.withUTF8String(cstring(shaderSource)),
  MTLCompileOptions(nil),
  addr error,
)
if library.isNil:
  echo error
  quit "Failed to compile Metal shaders"

let vertexFunction =
  newFunctionWithName(library, NSString.withUTF8String(cstring("vs_main")))
let fragmentFunction =
  newFunctionWithName(library, NSString.withUTF8String(cstring("fs_main")))
if vertexFunction.isNil or fragmentFunction.isNil:
  quit "Failed to find Metal shader functions"

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

let queue = newCommandQueue(device)
if queue.isNil:
  quit "Failed to create command queue"

var event: Event
var running = true

proc drawFrame() =
  var w, h: cint
  discard getRendererOutputSize(renderer, addr w, addr h)
  metalLayer.setDrawableSize(CGSize(width: w.float, height: h.float))

  let drawable = metalLayer.nextDrawable()
  if drawable.isNil:
    return

  let passDescriptor = MTLRenderPassDescriptor.renderPassDescriptor()
  let colorAttachment = objectAtIndexedSubscript(colorAttachments(passDescriptor), 0)
  setTexture(colorAttachment, texture(drawable))
  setLoadAction(colorAttachment, MTLLoadActionClear)
  setStoreAction(colorAttachment, MTLStoreActionStore)
  setClearColor(
    colorAttachment, MTLClearColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
  )

  let buffer = commandBuffer(queue)
  let encoder = renderCommandEncoderWithDescriptor(buffer, passDescriptor)
  setRenderPipelineState(encoder, pipelineState)
  setVertexBuffer(encoder, vertexBuffer, 0, 0)
  drawPrimitives(encoder, MTLPrimitiveType(3), 0, 3)
  endEncoding(encoder)
  presentDrawable(buffer, cast[MTLDrawable](drawable))
  commit(buffer)

while running:
  while pollEvent(event):
    if event.kind == QuitEvent:
      running = false

  drawFrame()

destroy(renderer)
destroy(window)
sdl2.quit()
