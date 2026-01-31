# metalx

Nim bindings for Metal (1–3) and Metal 4, plus a macOS Windy example that renders a Metal triangle using `CAMetalLayer`.

## Requirements
- macOS with Xcode Command Line Tools
- Nim 2.0.10+

## Using

```sh
atlas use https://github.com/elcritch/metalx
nimble install https://github.com/elcritch/metalx # if you must, will break on older Nimble without "feature" support
```

## Build & Test
```sh
atlas install --feature:test
nim test
```

## Example: Metal triangle with Windy (macOS)
This example uses Windy’s macOS window, grabs the underlying `NSWindow` via
`importutils.privateAccess`, and attaches a `CAMetalLayer` to render a triangle.

```sh
nim r examples/metal_triangle_windy.nim
```

## Simple Metal setup (no window)
```nim
import darwin/foundation/nsstring
import metalx/metal

let device = MTLCreateSystemDefaultDevice()
if device.isNil:
  quit "No Metal device"

var err: NSError
let library = newLibraryWithSource(
  device,
  NSString.withUTF8String(cstring("""
#include <metal_stdlib>
using namespace metal;
vertex float4 vs_main(uint vid [[vertex_id]]) {
  return float4(0.0, 0.0, 0.0, 1.0);
}
fragment float4 fs_main() { return float4(1.0); }
""")),
  MTLCompileOptions(nil),
  addr err
)
if library.isNil:
  echo err

...
```

## Modules
- `src/metalx/metal.nim`: Metal 1–3 bindings
- `src/metalx/metal4.nim`: Metal 4 bindings
- `src/metalx/cametal.nim`: `CAMetalLayer` / `CAMetalDrawable` bindings
- `src/metalx/objc_owned.nim`: ARC/ORC-friendly retain/release wrappers for ObjC objects + autorelease pool helpers

## Memory management helpers (`metalx/objc_owned`)
Metal (and Foundation) objects returned from these bindings are Objective-C objects; Nim ARC/ORC does **not**
automatically `retain`/`release` them. If you create/recreate resources over time (textures, buffers, pipeline
states, etc.) or you create lots of autoreleased objects per frame (render pass descriptors, NSStrings, etc.),
use these helpers to avoid leaks.

```nim
import metalx/objc_owned
import metalx/metal

# 1) Draining autoreleased objects (typical: once per frame)
var framePool: AutoreleasePool
framePool.start()
defer: framePool.stop()

# 2) Owning Metal/ObjC objects under Nim ARC/ORC
var device: ObjcOwned[MTLDevice]
device.resetRetained(MTLCreateSystemDefaultDevice()) # returned retained

var queue: ObjcOwned[MTLCommandQueue]
queue.resetRetained(newCommandQueue(device.borrow))  # `new*` is retained

# 3) Handling "borrowed"/autoreleased results
var cmd: ObjcOwned[MTLCommandBuffer]
cmd.resetBorrowed(commandBuffer(queue.borrow))       # `commandBuffer` is autoreleased/+0
commit(cmd.borrow)

# When `device`/`queue`/`cmd` go out of scope (or are overwritten), ObjcOwned calls `release`.
```
