import unittest
import darwin/objc/runtime
import darwin/foundation/[nserror, nsstring]
import metalx/metal

suite "metal 1-3 wrappers":
  test "compiles core symbols":
    check compiles(MTLCreateSystemDefaultDevice())
    check compiles(newCommandQueue(MTLDevice(nil)))
    check compiles(
      renderCommandEncoderWithDescriptor(
        MTLCommandBuffer(nil), MTLRenderPassDescriptor(nil)
      )
    )
    var err: NSError
    check compiles(
      newLibraryWithSource(
        MTLDevice(nil),
        NSString.withUTF8String(cstring("")),
        MTLCompileOptions(nil),
        addr err,
      )
    )
    check compiles(
      newRenderPipelineStateWithDescriptor(
        MTLDevice(nil), MTLRenderPipelineDescriptor(nil), addr err
      )
    )

  test "triangle render path compiles":
    check compiles(setVertexBuffer(MTLRenderCommandEncoder(nil), MTLBuffer(nil), 0, 0))
    check compiles(
      drawPrimitives(MTLRenderCommandEncoder(nil), MTLPrimitiveType(0), 0, 3)
    )

  test "triangle render path runtime (best effort)":
    let device = MTLCreateSystemDefaultDevice()
    if device.isNil:
      skip()
    if objcClass(MTLRenderPassDescriptor).isNil:
      skip()

    let queue = newCommandQueue(device)
    if queue.isNil:
      skip()
    let commandBuffer = commandBuffer(queue)
    if commandBuffer.isNil:
      skip()

    let passDescriptor = MTLRenderPassDescriptor.alloc().init()
    if passDescriptor.isNil:
      skip()

    let colorArray = colorAttachments(passDescriptor)
    if not colorArray.isNil and
        not objcClass(MTLRenderPassColorAttachmentDescriptor).isNil:
      let color0 = MTLRenderPassColorAttachmentDescriptor.alloc().init()
      if not color0.isNil:
        setObjectAtIndexedSubscript(colorArray, color0, 0)
        if respondsToSelector(color0, "setLoadAction:"):
          setLoadAction(color0, MTLLoadAction(0))
        if respondsToSelector(color0, "setStoreAction:"):
          setStoreAction(color0, MTLStoreAction(0))
        if respondsToSelector(color0, "setClearColor:"):
          setClearColor(
            color0, MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
          )

    let encoder = renderCommandEncoderWithDescriptor(commandBuffer, passDescriptor)
    if not encoder.isNil:
      endEncoding(encoder)
    if respondsToSelector(commandBuffer, "commit"):
      commit(commandBuffer)
