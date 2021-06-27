#!/bin/bash
set -ex

meson install -C build

# Create the DMG
cat > lite-xl-dmg.json << EOF
{
  "title": "Lite XL",
  "icon": "${APPVEYOR_BUILD_FOLDER}/dev-utils/icon.icns",
  "background-color": "#302e31",
  "contents": [
    { "x": 448, "y": 344, "type": "link", "path": "/Applications" },
    { "x": 192, "y": 344, "type": "file", "path": "${APPVEYOR_BUILD_FOLDER}/lite-xl.app" }
  ]
}
EOF
~/node_modules/appdmg/bin/appdmg.js lite-xl-dmg.json "${INSTALL_DIR}.dmg"
