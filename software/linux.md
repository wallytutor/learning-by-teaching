# Working on Linux

## Gnome 3

Several recent Linux distributions use Gnome 3 as the default desktop manager. A few *innovations* introduced by this environment are not really interesting and falling back to classical modes is useful:

- [Add minimize/maximize buttons to the corner of windows](https://askubuntu.com/questions/651347)
- [Include a permanent configurable dock for applications](https://micheleg.github.io/dash-to-dock/)

## Creating an AppImage installer

An *AppImage* application is a bundle intended to be portable across many distributions. Its main inconvenient is that you manually need to give execution permissions and launch it from command line every time. 

The following snippet is aimed to automating an *AppImage* installation under Gnome 3. Simply replace the fields marked by `<something>` with the required names and run the script (requires admin rights).

```shell
#!/usr/bin/env bash
set -euo pipefail

NAME="<application-name>"
ICON="<application-icon>"

SOURCE_ICO="${ICON}.png"
SOURCE_APP="<application-image-name>.AppImage"

TARGET_DIR="/opt/${NAME}"
PIXMAPS="/usr/share/pixmaps"
APPLICATIONS="${HOME}/.local/share/applications"

sudo mkdir --parents ${TARGET_DIR}

sudo cp ${SOURCE_APP} ${TARGET_DIR}
sudo chmod u+x ${TARGET_DIR}/${SOURCE_APP}

sudo cp ${SOURCE_ICO} ${TARGET_DIR}
sudo ln -s ${TARGET_DIR}/${SOURCE_ICO} ${PIXMAPS}

echo "[Desktop Entry]
Type=Application
Name=${NAME}
Exec=${TARGET_DIR}/${SOURCE_APP}
Icon=${ICON}
Terminal=false" > ${APPLICATIONS}/${NAME}.desktop

update-desktop-database ~/.local/share/applications
echo "install ok"
```