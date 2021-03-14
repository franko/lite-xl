#include <stdio.h>
#include <SDL.h>
#include "api/api.h"
#include "renderer.h"

#ifdef _WIN32
  #include <windows.h>
#elif __linux__
  #include <unistd.h>
  #include <stdlib.h>
#elif __APPLE__
  #include <mach-o/dyld.h>
#endif


SDL_Window *window;


static double get_scale(void) {
  float dpi;
  SDL_GetDisplayDPI(0, NULL, &dpi, NULL);
#if _WIN32
  return dpi / 96.0;
#elif __linux__
  FILE *stream;
  char *xrdb = "xrdb -query | grep dpi | cut -f 2";

  // In case something goes wrong in popen (e.g., fork or exec calls) or any
  // other calls listed below we return the dpi equal to 1.
  if ((stream = popen(xrdb, "r")) == NULL)
    return 1.0;

  char *line = NULL;
  size_t buffer = 0;
  ssize_t length = getline(&line, &buffer, stream);

  if (length == -1) {
    free(line);
    pclose(stream);
    return 1.0;
  }

  if (pclose(stream)) {
    free(line);
    return 1.0;
  }

  dpi = strtol(line, NULL, 10) / 96.0;
  free(line);

  return dpi;
#else
  return 1.0;
#endif
}


static void get_exe_filename(char *buf, int sz) {
#if _WIN32
  int len = GetModuleFileName(NULL, buf, sz - 1);
  buf[len] = '\0';
#elif __linux__
  char path[512];
  sprintf(path, "/proc/%d/exe", getpid());
  int len = readlink(path, buf, sz - 1);
  buf[len] = '\0';
#elif __APPLE__
  unsigned size = sz;
  _NSGetExecutablePath(buf, &size);
#else
  strcpy(buf, "./lite");
#endif
}


static void init_window_icon(void) {
#ifndef _WIN32
  #include "../icon.inl"
  (void) icon_rgba_len; /* unused */
  SDL_Surface *surf = SDL_CreateRGBSurfaceFrom(
    icon_rgba, 64, 64,
    32, 64 * 4,
    0x000000ff,
    0x0000ff00,
    0x00ff0000,
    0xff000000);
  SDL_SetWindowIcon(window, surf);
  SDL_FreeSurface(surf);
#endif
}

#ifdef _WIN32
#define LITE_OS_HOME "USERPROFILE"
#define LITE_PATHSEP_PATTERN "\\\\"
#define LITE_NONPATHSEP_PATTERN "[^\\\\]+"
#else
#define LITE_OS_HOME "HOME"
#define LITE_PATHSEP_PATTERN "/"
#define LITE_NONPATHSEP_PATTERN "[^/]+"
#endif

int main(int argc, char **argv) {
#ifdef _WIN32
  HINSTANCE lib = LoadLibrary("user32.dll");
  int (*SetProcessDPIAware)() = (void*) GetProcAddress(lib, "SetProcessDPIAware");
  SetProcessDPIAware();
#endif

  SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS);
  SDL_EnableScreenSaver();
  SDL_EventState(SDL_DROPFILE, SDL_ENABLE);
  atexit(SDL_Quit);

#ifdef SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR /* Available since 2.0.8 */
  SDL_SetHint(SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR, "0");
#endif
#if SDL_VERSION_ATLEAST(2, 0, 5)
  SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");
#endif

  SDL_DisplayMode dm;
  SDL_GetCurrentDisplayMode(0, &dm);

  window = SDL_CreateWindow(
    "", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, dm.w * 0.8, dm.h * 0.8,
    SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_HIDDEN);
  init_window_icon();
  ren_init(window);

  lua_State *L;
init_lua:
  L = luaL_newstate();
  luaL_openlibs(L);
  api_load_libs(L);


  lua_newtable(L);
  for (int i = 0; i < argc; i++) {
    lua_pushstring(L, argv[i]);
    lua_rawseti(L, -2, i + 1);
  }
  lua_setglobal(L, "ARGS");

  lua_pushstring(L, SDL_GetPlatform());
  lua_setglobal(L, "PLATFORM");

  lua_pushnumber(L, get_scale());
  lua_setglobal(L, "SCALE");

  char exename[2048];
  get_exe_filename(exename, sizeof(exename));
  lua_pushstring(L, exename);
  lua_setglobal(L, "EXEFILE");

  const char *init_lite_code = \
    "local core\n"
    "xpcall(function()\n"
    "  HOME = os.getenv('" LITE_OS_HOME "')\n"
    "  local exedir = EXEFILE:match(\"^(.*)" LITE_PATHSEP_PATTERN LITE_NONPATHSEP_PATTERN "$\")\n"
    "  local prefix = exedir:match(\"^(.*)" LITE_PATHSEP_PATTERN "bin$\")\n"
    "  dofile((prefix and prefix .. '/share/lite-xl' or exedir .. '/data') .. '/core/start.lua')\n"
    "  core = require('core')\n"
    "  core.init()\n"
    "  core.run()\n"
    "end, function(err)\n"
    "  local error_dir\n"
    "  io.stdout:write('Error: '..tostring(err)..'\\n')\n"
    "  io.stdout:write(debug.traceback(nil, 4)..'\\n')\n"
    "  if core and core.on_error then\n"
    "    error_dir=USERDIR\n"
    "    pcall(core.on_error, err)\n"
    "  else\n"
    "    error_dir=system.absolute_path('.')\n"
    "    local fp = io.open('error.txt', 'wb')\n"
    "    fp:write('Error: ' .. tostring(err) .. '\\n')\n"
    "    fp:write(debug.traceback(nil, 4)..'\\n')\n"
    "    fp:close()\n"
    "  end\n"
    "  system.show_fatal_error('Lite XL internal error',\n"
    "    'An internal error occurred in a critical part of the application.\\n\\n'..\n"
    "    'Please verify the file \\\"error.txt\\\" in the directory '..error_dir)\n"
    "  os.exit(1)\n"
    "end)\n"
    "return core and core.restart_request\n";

  if (luaL_loadstring(L, init_lite_code)) {
    fprintf(stderr, "internal error when starting the application\n");
    exit(1);
  }
  lua_pcall(L, 0, 1, 0);
  if (lua_toboolean(L, -1)) {
    lua_close(L);
    goto init_lua;
  }

  lua_close(L);
  SDL_DestroyWindow(window);

  return EXIT_SUCCESS;
}
