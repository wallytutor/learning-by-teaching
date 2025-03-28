# Fresh Ubuntu

This document provides the basic steps to setup a working Ubuntu system for scientific computing. It includes the general setup and customization steps. For more on #linux, please visit the dedicated [page](linux.md).

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

## Mount a NTFS drive

Add permanent mount points to external (NTFS) drives; use this section with care because this evolves between different versions of the packages. Tested and validated under Xubuntu 24.04.

```bash
# Install the required packages:
sudo apt install ntfs-3g

# Identify the disk to be mounted:
sudo parted -l

# Identify the UUID of the disk:
ls -alt /dev/disk/by-uuid/

# Test if mounting works:
sudo mount -t ntfs3 /dev/<drive> /home/<mountpoint>/

# Open fstab for edition:
sudo vim /etc/fstab

# Add a single line with the following:
# /dev/disk/by-uuid/<UUID> /home/<mountpoint>/ ntfs  defaults,uid=1000,gid=1000,umask=0022 0 0

# Check fstab for errors:
sudo findmnt --verify

# Maybe 
sudo systemctl daemon-reload
```

## Version control

Install `git` (and `gh` if using GitHub) and configure credentials:

```bash
sudo apt install git gh

git config --global user.email "walter.dalmazsilva@gmail.com"
git config --global user.name "Walter Dal'Maz Silva"

# (optional)
gh auth login
```

## Scientific computing

Install a good editor such as [Zed](https://zed.dev/download).

```bash
sudo apt install neovim curl terminator
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
