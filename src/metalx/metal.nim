import darwin/objc/runtime
import darwin/foundation/[nserror, nsstring]

{.passL: "-framework Metal".}
{.passL: "-framework CoreGraphics".}

type
  DispatchQueue* = pointer

  MTLPixelFormat* = distinct NSUInteger
  MTLPrimitiveType* = distinct NSUInteger
  MTLLoadAction* = distinct NSUInteger
  MTLStoreAction* = distinct NSUInteger

  MTLClearColor* = object
    red*: cdouble
    green*: cdouble
    blue*: cdouble
    alpha*: cdouble

  MTLDevice* = ptr object of NSObject
  MTLBuffer* = ptr object of NSObject
  MTLTexture* = ptr object of NSObject
  MTLLibrary* = ptr object of NSObject
  MTLFunction* = ptr object of NSObject
  MTLCompileOptions* = ptr object of NSObject
  MTLRenderPipelineState* = ptr object of NSObject
  MTLRenderPipelineDescriptor* = ptr object of NSObject
  MTLRenderPipelineColorAttachmentDescriptor* = ptr object of NSObject
  MTLRenderPipelineColorAttachmentDescriptorArray* = ptr object of NSObject
  MTLVertexDescriptor* = ptr object of NSObject
  MTLRenderPassDescriptor* = ptr object of NSObject
  MTLRenderPassColorAttachmentDescriptor* = ptr object of NSObject
  MTLRenderPassColorAttachmentDescriptorArray* = ptr object of NSObject
  MTLRenderCommandEncoder* = ptr object of NSObject
  MTLCommandQueue* = ptr object of NSObject
  MTLCommandBuffer* = ptr object of NSObject

proc MTLCreateSystemDefaultDevice*(): MTLDevice {.importc.}

proc newCommandQueue*(device: MTLDevice): MTLCommandQueue {.objc: "newCommandQueue".}
proc commandBuffer*(q: MTLCommandQueue): MTLCommandBuffer {.objc: "commandBuffer".}
proc waitUntilCompleted*(b: MTLCommandBuffer) {.objc: "waitUntilCompleted".}
proc status*(b: MTLCommandBuffer): NSUInteger {.objc: "status".}
proc error*(b: MTLCommandBuffer): NSError {.objc: "error".}

proc newLibraryWithSource*(
  device: MTLDevice, source: NSString, options: MTLCompileOptions, error: ptr NSError
): MTLLibrary {.objc: "newLibraryWithSource:options:error:".}

proc newRenderPipelineStateWithDescriptor*(
  device: MTLDevice, descriptor: MTLRenderPipelineDescriptor, error: ptr NSError
): MTLRenderPipelineState {.objc: "newRenderPipelineStateWithDescriptor:error:".}

proc renderCommandEncoderWithDescriptor*(
  b: MTLCommandBuffer, descriptor: MTLRenderPassDescriptor
): MTLRenderCommandEncoder {.objc: "renderCommandEncoderWithDescriptor:".}

proc endEncoding*(e: MTLRenderCommandEncoder) {.objc: "endEncoding".}
proc commit*(b: MTLCommandBuffer) {.objc: "commit".}

proc setRenderPipelineState*(
  e: MTLRenderCommandEncoder, state: MTLRenderPipelineState
) {.objc: "setRenderPipelineState:".}

proc setVertexBuffer*(
  e: MTLRenderCommandEncoder, buffer: MTLBuffer, offset: NSUInteger, index: NSUInteger
) {.objc: "setVertexBuffer:offset:atIndex:".}

proc drawPrimitives*(
  e: MTLRenderCommandEncoder,
  primType: MTLPrimitiveType,
  vertexStart: NSUInteger,
  vertexCount: NSUInteger,
) {.objc: "drawPrimitives:vertexStart:vertexCount:".}

proc vertexFunction*(
  d: MTLRenderPipelineDescriptor
): MTLFunction {.objc: "vertexFunction".}

proc setVertexFunction*(
  d: MTLRenderPipelineDescriptor, f: MTLFunction
) {.objc: "setVertexFunction:".}

proc fragmentFunction*(
  d: MTLRenderPipelineDescriptor
): MTLFunction {.objc: "fragmentFunction".}

proc setFragmentFunction*(
  d: MTLRenderPipelineDescriptor, f: MTLFunction
) {.objc: "setFragmentFunction:".}

proc vertexDescriptor*(
  d: MTLRenderPipelineDescriptor
): MTLVertexDescriptor {.objc: "vertexDescriptor".}

proc setVertexDescriptor*(
  d: MTLRenderPipelineDescriptor, descriptor: MTLVertexDescriptor
) {.objc: "setVertexDescriptor:".}

proc colorAttachments*(
  d: MTLRenderPipelineDescriptor
): MTLRenderPipelineColorAttachmentDescriptorArray {.objc: "colorAttachments".}

proc objectAtIndexedSubscript*(
  a: MTLRenderPipelineColorAttachmentDescriptorArray, index: NSUInteger
): MTLRenderPipelineColorAttachmentDescriptor {.objc: "objectAtIndexedSubscript:".}

proc setObjectAtIndexedSubscript*(
  a: MTLRenderPipelineColorAttachmentDescriptorArray,
  attachment: MTLRenderPipelineColorAttachmentDescriptor,
  index: NSUInteger,
) {.objc: "setObject:atIndexedSubscript:".}

proc pixelFormat*(
  d: MTLRenderPipelineColorAttachmentDescriptor
): MTLPixelFormat {.objc: "pixelFormat".}

proc setPixelFormat*(
  d: MTLRenderPipelineColorAttachmentDescriptor, format: MTLPixelFormat
) {.objc: "setPixelFormat:".}

proc colorAttachments*(
  d: MTLRenderPassDescriptor
): MTLRenderPassColorAttachmentDescriptorArray {.objc: "colorAttachments".}

proc objectAtIndexedSubscript*(
  a: MTLRenderPassColorAttachmentDescriptorArray, index: NSUInteger
): MTLRenderPassColorAttachmentDescriptor {.objc: "objectAtIndexedSubscript:".}

proc setObjectAtIndexedSubscript*(
  a: MTLRenderPassColorAttachmentDescriptorArray,
  attachment: MTLRenderPassColorAttachmentDescriptor,
  index: NSUInteger,
) {.objc: "setObject:atIndexedSubscript:".}

proc texture*(d: MTLRenderPassColorAttachmentDescriptor): MTLTexture {.objc: "texture".}
proc setTexture*(
  d: MTLRenderPassColorAttachmentDescriptor, texture: MTLTexture
) {.objc: "setTexture:".}

proc loadAction*(
  d: MTLRenderPassColorAttachmentDescriptor
): MTLLoadAction {.objc: "loadAction".}

proc setLoadAction*(
  d: MTLRenderPassColorAttachmentDescriptor, action: MTLLoadAction
) {.objc: "setLoadAction:".}

proc storeAction*(
  d: MTLRenderPassColorAttachmentDescriptor
): MTLStoreAction {.objc: "storeAction".}

proc setStoreAction*(
  d: MTLRenderPassColorAttachmentDescriptor, action: MTLStoreAction
) {.objc: "setStoreAction:".}

proc clearColor*(
  d: MTLRenderPassColorAttachmentDescriptor
): MTLClearColor {.objc: "clearColor".}

proc setClearColor*(
  d: MTLRenderPassColorAttachmentDescriptor, color: MTLClearColor
) {.objc: "setClearColor:".}
