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
