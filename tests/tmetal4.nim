import unittest
import metalx/metal4

suite "metal4 wrappers":
  test "compiles core symbols":
    check compiles(MTLCreateSystemDefaultDevice())
    check compiles(newMTL4CommandQueue(MTLDevice(nil)))
    check compiles(renderCommandEncoderWithDescriptor(
      MTL4CommandBuffer(nil),
      MTL4RenderPassDescriptor(nil),
      MTL4RenderEncoderOptions(0)
    ))

  test "clear color fields assignable":
    var color: MTLClearColor
    color.red = 1.0
    color.green = 0.5
    color.blue = 0.25
    color.alpha = 1.0
    check color.red == 1.0
