# Fresh Ubuntu

## Getting started

First of all, become a password-less *sudoer*, run `sudo visudo` by adding the following lines to the end of the file (by replacing `walter` by your own user name):

```text
walter  ALL=(ALL:ALL) ALL
Defaults:walter !authenticate
```

Then update the system:

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove
```

Install a temperature monitor cause scientific computing can burn:

```bash
sudo apt install lm-sensors xfce4-sensors-plugin
```

## Version control

Install `git` and configure credentials:

```bash
sudo apt install git
git config --global user.email "walter.dalmazsilva@gmail.com"
git config --global user.name "Walter Dal'Maz Silva"
```

## Scientific computing

Install a good editor such as [Zed](https://zed.dev/download).

```bash
sudo apt install curl terminator
```

```bash
sudo apt install python3-pip python3-venv
```

## Personal configuration

1. Add a secondary panel on the bottom with a few launchers for office work.
2. Modify file explorer default view mode to show detailed lists.
3. Edit `~/.config/users-dirs.dirs` to remove (some) of the default home directories.

```text
XDG_DESKTOP_DIR="$HOME/"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/.Templates"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/"
```

4. Download `.deb` packages of Edge, Obsidian and Zettlr.
5. Add user applications folder:

```bash
function add_extra_path() {
	export PATH=$HOME/.local/bin:$PATH
	
	if [ -d ~/Applications ]; then
	    for extrapath in ~/Applications/*; do
	        PATH="$extrapath:$PATH"
	    done
	fi
	
	unset extrapath
}
```
