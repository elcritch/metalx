import darwin/objc/runtime
import darwin/app_kit/nsview
import darwin/app_kit/nswindow

when not defined(macosx):
  {.error: "metalx/view: macOS only".}

proc attachMetalHostView*(window: NSWindow): NSView =
  let existingView = window.contentView()
  let metalHostView = NSView.alloc().initWithFrame(existingView.bounds())
  metalHostView.setAutoresizingMask(
    NSAutoresizingMaskOptions(NSViewWidthSizable.ord or NSViewHeightSizable.ord)
  )
  metalHostView.setWantsLayer(true)
  existingView.addSubview(metalHostView)
  result = metalHostView

export nsview, nswindow
