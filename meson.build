project('lite-xl', 'c', 'cpp', version : '2.0.0', default_options : ['c_std=gnu11', 'cpp_std=c++03'])

conf_data = configuration_data()
conf_data.set('PROJECT_BUILD_DIR', meson.current_build_dir())
conf_data.set('PROJECT_SOURCE_DIR', meson.current_source_dir())
conf_data.set('PROJECT_VERSION', meson.project_version())

if host_machine.system() == 'darwin'
    add_languages('objc')
endif

cc = meson.get_compiler('c')
libm = cc.find_library('m', required : false)
libdl = cc.find_library('dl', required : false)
libx11 = dependency('x11', required : false)
lua_dep = dependency('lua5.2', required : false)
pcre2_dep = dependency('libpcre2-8')
sdl_dep = dependency('sdl2', method: 'config-tool')

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

lite_cargs = []
if get_option('portable')
    lite_docdir = 'doc'
    lite_datadir = 'data'
else
    lite_docdir = 'share/doc/lite-xl'
    lite_datadir = 'share/lite-xl'
endif

lite_include = include_directories('src')
foreach data_module : ['core', 'fonts', 'plugins', 'colors']
    install_subdir('data' / data_module , install_dir : lite_datadir)
endforeach

install_data('licenses/licenses.md', install_dir : lite_docdir)

lite_link_args = []
if cc.get_id() == 'gcc' and get_option('buildtype') == 'release'
    lite_link_args += ['-static-libgcc', '-static-libstdc++']
endif
if host_machine.system() == 'darwin'
    lite_link_args += ['-framework', 'CoreServices', '-framework', 'Foundation']
endif

lite_rc = []
if host_machine.system() == 'windows'
    windows = import('windows')
    lite_rc += windows.compile_resources('resources/icons/icon.rc')
    iss = configure_file(input : 'scripts/innosetup/innosetup.iss.in',
        output : 'innosetup.iss',
        configuration : conf_data)
endif

# On macos we need to use the SDL renderer to support retina displays
if get_option('renderer') or host_machine.system() == 'darwin'
    lite_cargs += '-DLITE_USE_SDL_RENDERER'
endif

subdir('lib/font_renderer')
subdir('src')
