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

## Modules
- `src/metalx/metal.nim`: Metal 1–3 bindings
- `src/metalx/metal4.nim`: Metal 4 bindings
- `src/metalx/cametal.nim`: `CAMetalLayer` / `CAMetalDrawable` bindings

