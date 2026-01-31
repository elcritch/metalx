import darwin/objc/runtime
import darwin/foundation/[nserror, nsstring]

{.passL: "-framework Metal".}
{.passL: "-framework CoreGraphics".}

type
  DispatchQueue* = pointer

  MTLPixelFormat* = distinct NSUInteger
  MTLBlendFactor* = distinct NSUInteger
  MTLBlendOperation* = distinct NSUInteger
  MTLColorWriteMask* = distinct NSUInteger
  MTLPrimitiveTopologyClass* = distinct NSUInteger
  MTLPrimitiveType* = distinct NSUInteger
  MTLLoadAction* = distinct NSUInteger
  MTLStoreAction* = distinct NSUInteger
  MTLVisibilityResultType* = distinct NSUInteger

  MTL4RenderEncoderOptions* = distinct uint64
  MTL4BlendState* = distinct NSUInteger
  MTL4AlphaToCoverageState* = distinct NSUInteger
  MTL4AlphaToOneState* = distinct NSUInteger

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
  MTLFunctionConstantValues* = ptr object of NSObject
  MTLCompileOptions* = ptr object of NSObject
  MTLRenderPipelineState* = ptr object of NSObject
  MTLVertexDescriptor* = ptr object of NSObject
  MTLRenderPassColorAttachmentDescriptor* = ptr object of NSObject
  MTLRenderPassColorAttachmentDescriptorArray* = ptr object of NSObject
  MTLRenderPassDepthAttachmentDescriptor* = ptr object of NSObject
  MTLRenderPassStencilAttachmentDescriptor* = ptr object of NSObject
  MTLDrawable* = ptr object of NSObject
  MTLEvent* = ptr object of NSObject

  MTL4PipelineDescriptor* = ptr object of NSObject
  MTL4FunctionDescriptor* = ptr object of NSObject

  MTL4CompilerDescriptor* = ptr object of NSObject
  MTL4CompilerTaskOptions* = ptr object of NSObject
  MTL4Compiler* = ptr object of NSObject

  MTL4LibraryDescriptor* = ptr object of NSObject
  MTL4LibraryFunctionDescriptor* = ptr object of NSObject
  MTL4SpecializedFunctionDescriptor* = ptr object of NSObject

  MTL4RenderPipelineDescriptor* = ptr object of NSObject
  MTL4RenderPipelineColorAttachmentDescriptor* = ptr object of NSObject
  MTL4RenderPipelineColorAttachmentDescriptorArray* = ptr object of NSObject

  MTL4RenderPassDescriptor* = ptr object of NSObject
  MTL4RenderCommandEncoder* = ptr object of NSObject

  MTL4CommandAllocatorDescriptor* = ptr object of NSObject
  MTL4CommandAllocator* = ptr object of NSObject
  MTL4ArgumentTableDescriptor* = ptr object of NSObject
  MTL4ArgumentTable* = ptr object of NSObject
  MTL4CommandBufferOptions* = ptr object of NSObject
  MTL4CommandBuffer* = ptr object of NSObject
  MTL4CommitOptions* = ptr object of NSObject
  MTL4CommitFeedback* = ptr object of NSObject
  MTL4CommandQueueDescriptor* = ptr object of NSObject
  MTL4CommandQueue* = ptr object of NSObject

proc MTLCreateSystemDefaultDevice*(): MTLDevice {.importc.}

proc newMTL4CommandQueue*(device: MTLDevice): MTL4CommandQueue {.objc: "newMTL4CommandQueue".}
proc newMTL4CommandQueueWithDescriptor*(
  device: MTLDevice,
  descriptor: MTL4CommandQueueDescriptor,
  error: ptr NSError
): MTL4CommandQueue {.objc: "newMTL4CommandQueueWithDescriptor:error:".}
proc newCommandBuffer*(device: MTLDevice): MTL4CommandBuffer {.objc: "newCommandBuffer".}
proc newCommandAllocatorWithDescriptor*(
  device: MTLDevice,
  descriptor: MTL4CommandAllocatorDescriptor,
  error: ptr NSError
): MTL4CommandAllocator {.objc: "newCommandAllocatorWithDescriptor:error:".}
proc newArgumentTableWithDescriptor*(
  device: MTLDevice,
  descriptor: MTL4ArgumentTableDescriptor,
  error: ptr NSError
): MTL4ArgumentTable {.objc: "newArgumentTableWithDescriptor:error:".}
proc newCompilerWithDescriptor*(
  device: MTLDevice,
  descriptor: MTL4CompilerDescriptor,
  error: ptr NSError
): MTL4Compiler {.objc: "newCompilerWithDescriptor:error:".}

proc label*(d: MTL4CommandQueueDescriptor): NSString {.objc: "label".}
proc setLabel*(d: MTL4CommandQueueDescriptor, label: NSString) {.objc: "setLabel:".}
proc feedbackQueue*(d: MTL4CommandQueueDescriptor): DispatchQueue {.objc: "feedbackQueue".}
proc setFeedbackQueue*(d: MTL4CommandQueueDescriptor, queue: DispatchQueue) {.objc: "setFeedbackQueue:".}

proc device*(q: MTL4CommandQueue): MTLDevice {.objc: "device".}
proc label*(q: MTL4CommandQueue): NSString {.objc: "label".}
proc setLabel*(q: MTL4CommandQueue, label: NSString) {.objc: "setLabel:".}
proc commit*(
  q: MTL4CommandQueue,
  commandBuffers: ptr MTL4CommandBuffer,
  count: NSUInteger
) {.objc: "commit:count:".}
proc commit*(
  q: MTL4CommandQueue,
  commandBuffers: ptr MTL4CommandBuffer,
  count: NSUInteger,
  options: MTL4CommitOptions
) {.objc: "commit:count:options:".}

proc renderCommandEncoderWithDescriptor*(
  b: MTL4CommandBuffer,
  descriptor: MTL4RenderPassDescriptor,
  options: MTL4RenderEncoderOptions
): MTL4RenderCommandEncoder {.objc: "renderCommandEncoderWithDescriptor:options:".}
proc endCommandBuffer*(b: MTL4CommandBuffer) {.objc: "endCommandBuffer".}

proc setRenderPipelineState*(e: MTL4RenderCommandEncoder, state: MTLRenderPipelineState) {.objc: "setRenderPipelineState:".}
proc setVertexBuffer*(
  e: MTL4RenderCommandEncoder,
  buffer: MTLBuffer,
  offset: NSUInteger,
  index: NSUInteger
) {.objc: "setVertexBuffer:offset:atIndex:".}
proc drawPrimitives*(
  e: MTL4RenderCommandEncoder,
  primType: MTLPrimitiveType,
  vertexStart: NSUInteger,
  vertexCount: NSUInteger
) {.objc: "drawPrimitives:vertexStart:vertexCount:".}
proc endEncoding*(e: MTL4RenderCommandEncoder) {.objc: "endEncoding".}

proc colorAttachments*(d: MTL4RenderPassDescriptor): MTLRenderPassColorAttachmentDescriptorArray {.objc: "colorAttachments".}
proc depthAttachment*(d: MTL4RenderPassDescriptor): MTLRenderPassDepthAttachmentDescriptor {.objc: "depthAttachment".}
proc stencilAttachment*(d: MTL4RenderPassDescriptor): MTLRenderPassStencilAttachmentDescriptor {.objc: "stencilAttachment".}
proc renderTargetWidth*(d: MTL4RenderPassDescriptor): NSUInteger {.objc: "renderTargetWidth".}
proc setRenderTargetWidth*(d: MTL4RenderPassDescriptor, width: NSUInteger) {.objc: "setRenderTargetWidth:".}
proc renderTargetHeight*(d: MTL4RenderPassDescriptor): NSUInteger {.objc: "renderTargetHeight".}
proc setRenderTargetHeight*(d: MTL4RenderPassDescriptor, height: NSUInteger) {.objc: "setRenderTargetHeight:".}
proc defaultRasterSampleCount*(d: MTL4RenderPassDescriptor): NSUInteger {.objc: "defaultRasterSampleCount".}
proc setDefaultRasterSampleCount*(d: MTL4RenderPassDescriptor, count: NSUInteger) {.objc: "setDefaultRasterSampleCount:".}

proc objectAtIndexedSubscript*(
  a: MTLRenderPassColorAttachmentDescriptorArray,
  index: NSUInteger
): MTLRenderPassColorAttachmentDescriptor {.objc: "objectAtIndexedSubscript:".}
proc setObjectAtIndexedSubscript*(
  a: MTLRenderPassColorAttachmentDescriptorArray,
  attachment: MTLRenderPassColorAttachmentDescriptor,
  index: NSUInteger
) {.objc: "setObject:atIndexedSubscript:".}

proc texture*(d: MTLRenderPassColorAttachmentDescriptor): MTLTexture {.objc: "texture".}
proc setTexture*(d: MTLRenderPassColorAttachmentDescriptor, texture: MTLTexture) {.objc: "setTexture:".}
proc loadAction*(d: MTLRenderPassColorAttachmentDescriptor): MTLLoadAction {.objc: "loadAction".}
proc setLoadAction*(d: MTLRenderPassColorAttachmentDescriptor, action: MTLLoadAction) {.objc: "setLoadAction:".}
proc storeAction*(d: MTLRenderPassColorAttachmentDescriptor): MTLStoreAction {.objc: "storeAction".}
proc setStoreAction*(d: MTLRenderPassColorAttachmentDescriptor, action: MTLStoreAction) {.objc: "setStoreAction:".}
proc clearColor*(d: MTLRenderPassColorAttachmentDescriptor): MTLClearColor {.objc: "clearColor".}
proc setClearColor*(d: MTLRenderPassColorAttachmentDescriptor, color: MTLClearColor) {.objc: "setClearColor:".}

proc source*(d: MTL4LibraryDescriptor): NSString {.objc: "source".}
proc setSource*(d: MTL4LibraryDescriptor, source: NSString) {.objc: "setSource:".}
proc options*(d: MTL4LibraryDescriptor): MTLCompileOptions {.objc: "options".}
proc setOptions*(d: MTL4LibraryDescriptor, options: MTLCompileOptions) {.objc: "setOptions:".}
proc name*(d: MTL4LibraryDescriptor): NSString {.objc: "name".}
proc setName*(d: MTL4LibraryDescriptor, name: NSString) {.objc: "setName:".}

proc name*(d: MTL4LibraryFunctionDescriptor): NSString {.objc: "name".}
proc setName*(d: MTL4LibraryFunctionDescriptor, name: NSString) {.objc: "setName:".}
proc library*(d: MTL4LibraryFunctionDescriptor): MTLLibrary {.objc: "library".}
proc setLibrary*(d: MTL4LibraryFunctionDescriptor, library: MTLLibrary) {.objc: "setLibrary:".}

proc functionDescriptor*(d: MTL4SpecializedFunctionDescriptor): MTL4FunctionDescriptor {.objc: "functionDescriptor".}
proc setFunctionDescriptor*(d: MTL4SpecializedFunctionDescriptor, descriptor: MTL4FunctionDescriptor) {.objc: "setFunctionDescriptor:".}
proc specializedName*(d: MTL4SpecializedFunctionDescriptor): NSString {.objc: "specializedName".}
proc setSpecializedName*(d: MTL4SpecializedFunctionDescriptor, name: NSString) {.objc: "setSpecializedName:".}
proc constantValues*(d: MTL4SpecializedFunctionDescriptor): MTLFunctionConstantValues {.objc: "constantValues".}
proc setConstantValues*(d: MTL4SpecializedFunctionDescriptor, values: MTLFunctionConstantValues) {.objc: "setConstantValues:".}

proc vertexFunctionDescriptor*(d: MTL4RenderPipelineDescriptor): MTL4FunctionDescriptor {.objc: "vertexFunctionDescriptor".}
proc setVertexFunctionDescriptor*(d: MTL4RenderPipelineDescriptor, f: MTL4FunctionDescriptor) {.objc: "setVertexFunctionDescriptor:".}
proc fragmentFunctionDescriptor*(d: MTL4RenderPipelineDescriptor): MTL4FunctionDescriptor {.objc: "fragmentFunctionDescriptor".}
proc setFragmentFunctionDescriptor*(d: MTL4RenderPipelineDescriptor, f: MTL4FunctionDescriptor) {.objc: "setFragmentFunctionDescriptor:".}
proc vertexDescriptor*(d: MTL4RenderPipelineDescriptor): MTLVertexDescriptor {.objc: "vertexDescriptor".}
proc setVertexDescriptor*(d: MTL4RenderPipelineDescriptor, descriptor: MTLVertexDescriptor) {.objc: "setVertexDescriptor:".}
proc colorAttachments*(d: MTL4RenderPipelineDescriptor): MTL4RenderPipelineColorAttachmentDescriptorArray {.objc: "colorAttachments".}
proc inputPrimitiveTopology*(d: MTL4RenderPipelineDescriptor): MTLPrimitiveTopologyClass {.objc: "inputPrimitiveTopology".}
proc setInputPrimitiveTopology*(d: MTL4RenderPipelineDescriptor, topology: MTLPrimitiveTopologyClass) {.objc: "setInputPrimitiveTopology:".}

proc objectAtIndexedSubscript*(
  a: MTL4RenderPipelineColorAttachmentDescriptorArray,
  index: NSUInteger
): MTL4RenderPipelineColorAttachmentDescriptor {.objc: "objectAtIndexedSubscript:".}
proc setObjectAtIndexedSubscript*(
  a: MTL4RenderPipelineColorAttachmentDescriptorArray,
  attachment: MTL4RenderPipelineColorAttachmentDescriptor,
  index: NSUInteger
) {.objc: "setObject:atIndexedSubscript:".}
proc reset*(a: MTL4RenderPipelineColorAttachmentDescriptorArray) {.objc: "reset".}

proc pixelFormat*(d: MTL4RenderPipelineColorAttachmentDescriptor): MTLPixelFormat {.objc: "pixelFormat".}
proc setPixelFormat*(d: MTL4RenderPipelineColorAttachmentDescriptor, format: MTLPixelFormat) {.objc: "setPixelFormat:".}
proc blendingState*(d: MTL4RenderPipelineColorAttachmentDescriptor): MTL4BlendState {.objc: "blendingState".}
proc setBlendingState*(d: MTL4RenderPipelineColorAttachmentDescriptor, state: MTL4BlendState) {.objc: "setBlendingState:".}
proc writeMask*(d: MTL4RenderPipelineColorAttachmentDescriptor): MTLColorWriteMask {.objc: "writeMask".}
proc setWriteMask*(d: MTL4RenderPipelineColorAttachmentDescriptor, mask: MTLColorWriteMask) {.objc: "setWriteMask:".}
proc reset*(d: MTL4RenderPipelineColorAttachmentDescriptor) {.objc: "reset".}

proc newLibraryWithDescriptor*(
  c: MTL4Compiler,
  descriptor: MTL4LibraryDescriptor,
  error: ptr NSError
): MTLLibrary {.objc: "newLibraryWithDescriptor:error:".}
proc newRenderPipelineStateWithDescriptor*(
  c: MTL4Compiler,
  descriptor: MTL4PipelineDescriptor,
  compilerTaskOptions: MTL4CompilerTaskOptions,
  error: ptr NSError
): MTLRenderPipelineState {.objc: "newRenderPipelineStateWithDescriptor:compilerTaskOptions:error:".}
