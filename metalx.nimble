version       = "0.4.1"
author        = "Jaremy Creechley"
description   = "metal bindings"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 2.0.10"
requires "darwin#head"

feature "test":
  requires "windy"
  requires "sdl2"

