import sdl2

{.passL: "-Wl,-rpath,/opt/homebrew/lib".}

when defined(macosx):
  when not defined(SDL_Static):
    {.push callConv: cdecl, dynlib: LibName.}
  proc renderGetMetalLayer*(
    renderer: RendererPtr
  ): pointer {.importc: "SDL_RenderGetMetalLayer".}

  when not defined(SDL_Static):
    {.pop.}

const SDL_HINT_RENDER_DRIVER* = "SDL_HINT_RENDER_DRIVER"

export sdl2
