project(
    'lite-xl',
    ['c', 'cpp'],
    license : 'MIT',
    default_options : ['c_std=gnu11', 'cpp_std=c++03']
)
if host_machine.system() == 'darwin'
    add_languages('objc')
endif

# Dependencies

cc = meson.get_compiler('c')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)
libx11 = dependency('x11', required : false)
lua_dep = dependency('lua5.2', required : false)
pcre2_dep = dependency('libpcre2-8')

#if host_machine.system() == 'darwin'
#    sdl_method = 'pkg-config'
#else
sdl_method = 'config-tool'
#endif

sdl_dep = dependency('sdl2', method: sdl_method)

if not lua_dep.found()
    lua_subproject = subproject('lua', default_options: ['shared=false', 'use_readline=false', 'app=false'])
    lua_dep = lua_subproject.get_variable('lua_dep')
endif

reproc_subproject = subproject('reproc', default_options: ['default_library=static', 'multithreaded=false', 'reproc-cpp=false', 'examples=false'])
reproc_dep = reproc_subproject.get_variable('reproc_dep')

lite_deps = [lua_dep, sdl_dep, reproc_dep, pcre2_dep, libm, libdl, libx11]

if host_machine.system() == 'windows'
    # Note that we need to explicitly add the windows socket DLL because
    # the pkg-config file from reproc does not include it.
    lite_deps += meson.get_compiler('cpp').find_library('ws2_32', required: true)
endif

# Compiler Options

lite_rc = []
if host_machine.system() == 'windows'
    windows = import('windows')
    lite_rc += windows.compile_resources('res.rc')
endif

lite_include = include_directories('src')
lite_cargs = []

# On macos we need to use the SDL renderer to support retina displays
if get_option('renderer') or host_machine.system() == 'darwin'
    lite_cargs += '-DLITE_USE_SDL_RENDERER'
endif

# Linker Options

lite_link_args = []

if cc.get_id() == 'gcc' and get_option('buildtype') == 'release'
    lite_link_args += ['-static-libgcc', '-static-libstdc++']
endif

if host_machine.system() == 'darwin'
    lite_link_args += ['-framework', 'CoreServices', '-framework', 'Foundation']
endif

# Installations

if get_option('portable')
    lite_docdir = 'doc'
    lite_datadir = 'data'
elif host_machine.system() == 'darwin'
    lite_docdir = 'Contents/Resources'
    lite_datadir = 'Contents/Resources'
    install_data('dev-utils/icon.icns', install_dir : 'Contents/Resources')
    install_data('dev-utils/Info.plist', install_dir : 'Contents')
else
    lite_docdir = 'share/doc/lite-xl'
    lite_datadir = 'share/lite-xl'
endif

foreach data_module : ['core', 'fonts', 'plugins', 'colors']
    install_subdir('data' / data_module , install_dir : lite_datadir)
endforeach

install_data('licenses/licenses.md', install_dir : lite_docdir)

subdir('lib/font_renderer')
subdir('src')
