import unicode, vmath, windy/common

when defined(emscripten):
  import windy/platforms/emscripten/platform
elif defined(windows):
  import windy/platforms/win32/platform
elif defined(macosx):
  import std/importutils
  import darwin/app_kit/[nswindow, nsview]
  import darwin/objc/runtime
  import windy/platforms/macos/platform
elif defined(linux) or defined(bsd):
  import windy/platforms/linux/platform
else:
  {.error: "windyshim: unsupported OS".}

export common, platform, unicode, vmath

when defined(macosx):
  privateAccess(Window)

  proc cocoaWindow*(window: Window): NSWindow =
    cast[NSWindow](cast[pointer](window.inner.int))

  proc cocoaContentView*(window: Window): NSView =
    cocoaWindow(window).contentView()
