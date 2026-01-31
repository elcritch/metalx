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
  MTLResourceOptions* = distinct NSUInteger
  MTLTextureUsage* = distinct NSUInteger
  MTLStorageMode* = distinct NSUInteger
  MTLIndexType* = distinct NSUInteger
  MTLBlendFactor* = distinct NSUInteger
  MTLBlendOperation* = distinct NSUInteger

  MTLClearColor* = object
    red*: cdouble
    green*: cdouble
    blue*: cdouble
    alpha*: cdouble

  MTLDevice* = ptr object of NSObject
  MTLBuffer* = ptr object of NSObject
  MTLTexture* = ptr object of NSObject
  MTLTextureDescriptor* = ptr object of NSObject
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
  MTLDrawable* = ptr object of NSObject

  MTLOrigin* = object
    x*, y*, z*: NSUInteger

  MTLSize* = object
    width*, height*, depth*: NSUInteger

  MTLRegion* = object
    origin*: MTLOrigin
    size*: MTLSize

const
  MTLPixelFormatBGRA8Unorm* = MTLPixelFormat(80)
  MTLPixelFormatBGRA8Unorm_sRGB* = MTLPixelFormat(81)
  MTLPixelFormatRGBA8Unorm* = MTLPixelFormat(70)
  MTLPixelFormatR8Unorm* = MTLPixelFormat(10)

  MTLPrimitiveTypeTriangle* = MTLPrimitiveType(3)
  MTLLoadActionDontCare* = MTLLoadAction(0)
  MTLLoadActionLoad* = MTLLoadAction(1)
  MTLLoadActionClear* = MTLLoadAction(2)
  MTLStoreActionDontCare* = MTLStoreAction(0)
  MTLStoreActionStore* = MTLStoreAction(1)

  MTLTextureUsageShaderRead* = MTLTextureUsage(1)
  MTLTextureUsageRenderTarget* = MTLTextureUsage(4)

  MTLStorageModeShared* = MTLStorageMode(0)

  MTLIndexTypeUInt16* = MTLIndexType(0)

  MTLBlendFactorZero* = MTLBlendFactor(0)
  MTLBlendFactorOne* = MTLBlendFactor(1)
  MTLBlendFactorSourceAlpha* = MTLBlendFactor(4)
  MTLBlendFactorOneMinusSourceAlpha* = MTLBlendFactor(5)
  MTLBlendOperationAdd* = MTLBlendOperation(0)

proc MTLCreateSystemDefaultDevice*(): MTLDevice {.importc.}

proc newCommandQueue*(device: MTLDevice): MTLCommandQueue {.objc: "newCommandQueue".}
proc commandBuffer*(q: MTLCommandQueue): MTLCommandBuffer {.objc: "commandBuffer".}
proc waitUntilCompleted*(b: MTLCommandBuffer) {.objc: "waitUntilCompleted".}
proc status*(b: MTLCommandBuffer): NSUInteger {.objc: "status".}
proc error*(b: MTLCommandBuffer): NSError {.objc: "error".}
proc presentDrawable*(
  b: MTLCommandBuffer, drawable: MTLDrawable
) {.objc: "presentDrawable:".}

proc newLibraryWithSource*(
  device: MTLDevice, source: NSString, options: MTLCompileOptions, error: ptr NSError
): MTLLibrary {.objc: "newLibraryWithSource:options:error:".}

proc newFunctionWithName*(
  l: MTLLibrary, name: NSString
): MTLFunction {.objc: "newFunctionWithName:".}

proc newRenderPipelineStateWithDescriptor*(
  device: MTLDevice, descriptor: MTLRenderPipelineDescriptor, error: ptr NSError
): MTLRenderPipelineState {.objc: "newRenderPipelineStateWithDescriptor:error:".}

proc newBufferWithBytes*(
  device: MTLDevice, bytes: pointer, length: NSUInteger, options: MTLResourceOptions
): MTLBuffer {.objc: "newBufferWithBytes:length:options:".}

proc newBufferWithLength*(
  device: MTLDevice, length: NSUInteger, options: MTLResourceOptions
): MTLBuffer {.objc: "newBufferWithLength:options:".}

proc contents*(b: MTLBuffer): pointer {.objc: "contents".}

proc renderCommandEncoderWithDescriptor*(
  b: MTLCommandBuffer, descriptor: MTLRenderPassDescriptor
): MTLRenderCommandEncoder {.objc: "renderCommandEncoderWithDescriptor:".}

proc renderPassDescriptor*(
  t: typedesc[MTLRenderPassDescriptor]
): MTLRenderPassDescriptor {.objc: "renderPassDescriptor".}

proc endEncoding*(e: MTLRenderCommandEncoder) {.objc: "endEncoding".}
proc commit*(b: MTLCommandBuffer) {.objc: "commit".}

proc setRenderPipelineState*(
  e: MTLRenderCommandEncoder, state: MTLRenderPipelineState
) {.objc: "setRenderPipelineState:".}

proc setVertexBuffer*(
  e: MTLRenderCommandEncoder, buffer: MTLBuffer, offset: NSUInteger, index: NSUInteger
) {.objc: "setVertexBuffer:offset:atIndex:".}

proc setFragmentTexture*(
  e: MTLRenderCommandEncoder, texture: MTLTexture, index: NSUInteger
) {.objc: "setFragmentTexture:atIndex:".}

proc setVertexBytes*(
  e: MTLRenderCommandEncoder, bytes: pointer, length: NSUInteger, index: NSUInteger
) {.objc: "setVertexBytes:length:atIndex:".}

proc setFragmentBytes*(
  e: MTLRenderCommandEncoder, bytes: pointer, length: NSUInteger, index: NSUInteger
) {.objc: "setFragmentBytes:length:atIndex:".}

proc drawPrimitives*(
  e: MTLRenderCommandEncoder,
  primType: MTLPrimitiveType,
  vertexStart: NSUInteger,
  vertexCount: NSUInteger,
) {.objc: "drawPrimitives:vertexStart:vertexCount:".}

proc drawIndexedPrimitives*(
  e: MTLRenderCommandEncoder,
  primType: MTLPrimitiveType,
  indexCount: NSUInteger,
  indexType: MTLIndexType,
  indexBuffer: MTLBuffer,
  indexBufferOffset: NSUInteger,
) {.objc: "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:".}

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

proc setBlendingEnabled*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: bool
) {.objc: "setBlendingEnabled:".}

proc setSourceRGBBlendFactor*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendFactor
) {.objc: "setSourceRGBBlendFactor:".}

proc setDestinationRGBBlendFactor*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendFactor
) {.objc: "setDestinationRGBBlendFactor:".}

proc setRgbBlendOperation*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendOperation
) {.objc: "setRgbBlendOperation:".}

proc setSourceAlphaBlendFactor*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendFactor
) {.objc: "setSourceAlphaBlendFactor:".}

proc setDestinationAlphaBlendFactor*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendFactor
) {.objc: "setDestinationAlphaBlendFactor:".}

proc setAlphaBlendOperation*(
  d: MTLRenderPipelineColorAttachmentDescriptor, v: MTLBlendOperation
) {.objc: "setAlphaBlendOperation:".}

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

proc texture2DDescriptorWithPixelFormat*(
  cls: typedesc[MTLTextureDescriptor],
  pixelFormat: MTLPixelFormat,
  width: NSUInteger,
  height: NSUInteger,
  mipmapped: bool,
): MTLTextureDescriptor {.
  objc: "texture2DDescriptorWithPixelFormat:width:height:mipmapped:"
.}

proc usage*(d: MTLTextureDescriptor): MTLTextureUsage {.objc: "usage".}
proc setUsage*(d: MTLTextureDescriptor, u: MTLTextureUsage) {.objc: "setUsage:".}
proc storageMode*(d: MTLTextureDescriptor): MTLStorageMode {.objc: "storageMode".}
proc setStorageMode*(
  d: MTLTextureDescriptor, m: MTLStorageMode
) {.objc: "setStorageMode:".}

proc newTextureWithDescriptor*(
  device: MTLDevice, desc: MTLTextureDescriptor
): MTLTexture {.objc: "newTextureWithDescriptor:".}

proc replaceRegion*(
  t: MTLTexture,
  region: MTLRegion,
  mipmapLevel: NSUInteger,
  bytes: pointer,
  bytesPerRow: NSUInteger,
) {.objc: "replaceRegion:mipmapLevel:withBytes:bytesPerRow:".}

proc getBytes*(
  t: MTLTexture,
  bytes: pointer,
  bytesPerRow: NSUInteger,
  region: MTLRegion,
  mipmapLevel: NSUInteger,
) {.objc: "getBytes:bytesPerRow:fromRegion:mipmapLevel:".}

proc width*(t: MTLTexture): NSUInteger {.objc: "width".}
proc height*(t: MTLTexture): NSUInteger {.objc: "height".}

template copySeqToBuf[T](buf: MTLBuffer, src: seq[T], bytes: int) =
  let dst = buf.contents()
  assert not dst.isNil, "MTLBuffer cannot be nil"
  assert src.len() * sizeof(T) >= bytes, "buffer src too small"
  copyMem(dst, src[0].addr, bytes)

