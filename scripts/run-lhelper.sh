#!/bin/bash
source "/usr/local/.ghcup/var/lib/lhelper/environments/lite-xl"

lhelper install freetype2
lhelper install sdl2 2.0.14-wait-event-timeout-1
lhelper install pcre2

#meson setup --buildtype=release --prefix /usr build
#meson compile -C build
