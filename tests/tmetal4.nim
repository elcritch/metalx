import unittest
import darwin/objc/runtime
import darwin/foundation/nsstring
import metalx/metal4

suite "metal4 wrappers":
  test "compiles core symbols":
    check compiles(MTLCreateSystemDefaultDevice())
    check compiles(newMTL4CommandQueue(MTLDevice(nil)))
    check compiles(
      renderCommandEncoderWithDescriptor(
        MTL4CommandBuffer(nil),
        MTL4RenderPassDescriptor(nil),
        MTL4RenderEncoderOptions(0),
      )
    )

  test "clear color fields assignable":
    var color: MTLClearColor
    color.red = 1.0
    color.green = 0.5
    color.blue = 0.25
    color.alpha = 1.0
    check color.red == 1.0

  test "triangle render path compiles":
    check compiles(setVertexBuffer(MTL4RenderCommandEncoder(nil), MTLBuffer(nil), 0, 0))
    check compiles(
      drawPrimitives(MTL4RenderCommandEncoder(nil), MTLPrimitiveType(0), 0, 3)
    )

  test "triangle render path runtime (best effort)":
    let device = MTLCreateSystemDefaultDevice()
    if device.isNil:
      skip()
    if objcClass(MTL4CommandQueueDescriptor).isNil:
      skip()
    if objcClass(MTL4RenderPassDescriptor).isNil:
      skip()

    let queueDescriptor = MTL4CommandQueueDescriptor.alloc().init()
    if queueDescriptor.isNil:
      skip()
    if respondsToSelector(queueDescriptor, "setLabel:") and
        respondsToSelector(queueDescriptor, "label"):
      let labelStr = NSString.withUTF8String(cstring("metal4"))
      setLabel(queueDescriptor, labelStr)
      check label(queueDescriptor) == labelStr

    let passDescriptor = MTL4RenderPassDescriptor.alloc().init()
    if passDescriptor.isNil:
      skip()
    if respondsToSelector(passDescriptor, "setRenderTargetWidth:"):
      setRenderTargetWidth(passDescriptor, 4)
    if respondsToSelector(passDescriptor, "setRenderTargetHeight:"):
      setRenderTargetHeight(passDescriptor, 4)
    if respondsToSelector(passDescriptor, "setDefaultRasterSampleCount:"):
      setDefaultRasterSampleCount(passDescriptor, 1)

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
