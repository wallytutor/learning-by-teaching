# Software

## Scientific Computing

Notes related to my learning and teaching interests in several fields related to scientific computing (mostly applied mathematics and machine learning) and related applications. This home page is the entry point and those interested in more content and interesting links navigate below between the multiple pages. It can also be used as a general guide for introducing scientific computing as it tries to introduce the minimal skill set any scientific computing engineer or scientist should have:

- Version control comes first, everything else is worthless without it, currently that means Git.
- Next comes software documentation with Doxygen, Sphinx, and/or Documenter.jl.
- A low(er) level programming language among C, C++, and Fortran, preferably all of them.
- Scripting languages, as of 2024, Python is mandatory, Julia highly recommended.
- Basic machine learning in one of the above scripts, everything is ML these days.
- Shell automation, basis of both Bash/other UNIX shell and PowerShell are required.
- Typesetting equations reports and presentations (beamer) in LaTeX.
- Domain specific skills related to the field of study (CFD, DFT, MD, ML, ...).

A sample setup of an operating system for scientific computing and practicing the above skills is provided [here](ubuntu.md).

Some technologies have been mainstream or important in the past, but nowadays some of them have already died or are becoming too niche to be put in such a list. That is the case of SVN for version control. As for programming languages in science, that is the case of *matlabish* (MATLAB, Octave, Scilab) environments, which are still used by *controls and automation* people, but are mostly incompatible with good software practices and should be discouraged.

It is also worth getting familiar with high-performance computing (HPC); in the [Top 500](https://top500.org/) page you can get to know the most powerful computers on Earth.  The [specification benchmarking](https://spec.org/) page allows for the check of hardware specification, what is interesting when preparing investment in a computing structure. Lastly, when working in multi-user systems it is worth knowing about job management systems such as [Slurm](https://www.schedmd.com/).

As a last word, I would like to remember that it is humanly impossible to master everything at once; even after more than 10 years in the field as of today I only have a grasp in the tools I do not use everyday. Software and methods evolve, and unless you keep using a specific tool you simply cannot afford to keep up to date with it. That should not be a roadblock for a scientist in the long term. As you get used to scientific software, getting back to a good level of some tool you used in the past is quick (but not extremely fast in some cases) and learning new tools for which you already know the science behind is trivial. Even exploring new fields become easy in some cases.

### Command line basics

If this is you first time using the command prompt you might be interested by this section. The command prompt (often referred to as *terminal* in Linux world) is your interface to interact with the operating system and many available tools. To learn any useful scientific computing skills it is useful to get a grasp of its use because it is there that we will launch most applications. The illustrations below assume you are working under Windows, but the introductory commands are common to most operating systems. 

Now let's launch a terminal. If you are working under [VS Code](vscode.md) you can use the shortcut to display the terminal `Ctrl+J`; the bottom of your window should display something as

```console
PS D:\Kompanion>
```

The start of this line displays you *path* in the system; depending on your configuration that could not be the case and you can ask the OS to give you that with `pwd` (print working directory)

```console
PS D:\Kompanion> pwd

Path
----
D:\Kompanion
```

If you are invited to move to directory `src` you may which to use command *change directory*, or `cd` in the system's language

```console
PS D:\Kompanion> cd .\bin\
PS D:\Kompanion\bin> 
```

Now that you reached your destination, you might be interested at inspecting the contents of this directory, *i.e.* listing its contents; that is done with `ls` as follows

```console
PS D:\Kompanion\bin> ls


    Directory: D:\Kompanion\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         1/31/2025  11:11 AM                apps
d-----          2/3/2025   9:19 AM                data
d-----         1/30/2025   2:34 PM                downloads
d-----          2/3/2025  11:50 AM                pkgs
d-----         1/31/2025   9:33 AM                scripts
d-----         1/30/2025   9:58 AM                tests
-a----         1/31/2025   9:33 AM           2697 activate.bat
-a----         1/30/2025   9:58 AM            161 code.bat
-a----         1/30/2025   9:58 AM            132 kode.bat
-a----         1/30/2025   9:58 AM            131 kpip.bat
```

Oops! It was not the directory you wanted to go to! No problems, you can navigate *one-level-upwards* using the special symbol `..` (two dots) and change directory again

```console
PS D:\Kompanion\bin> cd ..\docs\
PS D:\Kompanion\docs> 
```

This is the minimum you need to know: navigate, know your address, inspect contents.

### Scientific software

#### Geometry

- [blender](https://www.blender.org/): the most powerful 3D (in the general sense) open source modeling tool; allows geometries to be exported to STL, which is compatible with most meshing software.

- [FreeCAD](freecad/basics.md): contrarily to [blender](https://www.blender.org/), this is the most mature open source modeling tool in the technical sense. It supports both 3D conception and detailed drawing, among other features.

- [cadquery](https://github.com/CadQuery/cadquery?tab=readme-ov-file): a simple parametric geometry tool.

#### Meshing

-  [gmsh](gmsh/basics.md): the *to-go* meshing tool for 2D geometries and visualization of many formats of 3D meshes; before trying to produce reliable structured meshes and geometry in 3D some ninja skills need to be developed. Its own scripting language makes parametric meshing easy.

- [MeshLab](https://github.com/cnr-isti-vclab/meshlab): allows to manipulate triangulated grids generated in CAD; helpful for preparing patches for use with #OpenFOAM/snappyHexMesh .

#### Rendering

- [ParaView](paraview/basics.md): the *de facto* post-processing tool for many fields of application. 
 
- [trame](https://kitware.github.io/trame/): rendering results in web-applications.

#### Simulation

- [Elmer](elmer/README.md): multiphysics FEM toolkit.

- [OpenFOAM](openfoam/README.md): general purpose FVM CFD toolkit.

- [TRUST Platform](https://cea-trust-platform.github.io/):  the basis for [TrioCFD](https://github.com/cea-trust-platform/TrioCFD-code) code by CEA.

#### Productivity

[Obsidian](https://obsidian.md/) is the *de facto* solution for note-taking and *second brain* management, but it is not free for commercial ends and that has become a problem for my intended work use. Looking for alternatives for this tool which is my main productivity setting, I came across the following packages. Testing was done with *I want it to be the same* mindset and if after a few minutes I was not convinced by the application, it was automatically discarded. In summary, I liked both *Joplin* and *Zettlr* but will pursue the use of the latter only as *Joplin* does not meet by criteria. *StandardNotes* is a false open-source package and *logseq* is still too raw for any production setting.

| Software                                                  | Pros                                                                                                                                    | Cons                                                                                                                                                                                                                                 |
| --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [laurent22/joplin](https://github.com/laurent22/joplin/)  | Rich interface with many features; excellent tool if you are not seeking version control as a target. Available as portable executable. | Counterintuitive interface and files are not directly stored as `.md`; file system synchronization requires and absolute path. After closing the executable, a process was kept alive.                                               |
| [logseq/logseq](https://github.com/logseq/logseq)         | Available as portable executable.                                                                                                       | Poor UI at first sight. Fast but *dumb* in the sense it will only support *one file* with a given title, what is incompatible with my way of organizing directories. Pages are not organized as in the folder view.                  |
| [standardnotes/app](https://github.com/standardnotes/app) | Interface is cleaner/less cluttered than Joplin. Available as portable executable.                                                      | Stopped using it as received the first notification that smart tags require a paid plan. Also only plain text files are supported in free mode.                                                                                      |
| [Zettlr/Zettlr](https://github.com/Zettlr/Zettlr)         | Support to YAML frontmatter. UI gets better as you open files. Integration to BibTeX.                                                   | Poor UI at first sight.  Not available as portable executable; but installation can be done in any user folder, what is also fine. It took a long time to import my existing *second brain* and sometimes it glitches/has some lags. |

#### Other

- [protobuf](https://protobuf.dev/getting-started/pythontutorial/): for parsing #OpenFOAM dictionaries from Python.

## General Tips

### Running Jupyterlab from a server

#programming/python/jupyter 

Before running the server it is a good idea to generate the user configuration file:

```bash
jupyter-lab --generate-config
```

By default it will be located at `~/.jupyter/jupyter_lab_config.py`. Now you can add your own access token that will simplify the following steps (and allow for reproducible connections in the future).

```python
c.IdentityProvider.token = '<YOUR_TOKEN>'
```

The idea is illustrated in [this](https://stackoverflow.com/questions/69244218) thread; first on the server side you need to start a headless service as provided below. Once Jupyter starts running, copy the token it will generate if you skipped the user configuration step above.

```bash
jupyter-lab --no-browser --port=8080
```

On the host side (the computer from where you wish to edit the notebooks) establish a ssh tunel exposing and mapping the port chose to serve Jupyter:

```bash
ssh -L 8080:localhost:8080 <REMOTE_USER>@<REMOTE_HOST>
```

Now you can browse to `http://localhost:8080/` and add the token you copied earlier or your user-token you added to the configuration file.

### Downloading from YouTube

#programming/python/tips 

Retrieving a video or playlist from YouTube can be automated with help of [yt-dlp](https://github.com/yt-dlp/yt-dlp).

To get the tool working under Ubuntu you can do the following:

```bash
# Install Python venv to create a local virtual environment:
sudo apt install python3-venv

# Create an homonymous environment:
python3 -m venv venv

# Activate the local environment:
source venv/bin/activate

# Use pip to install the tool:
pip install -U --pre "yt-dlp[default]"
```

**NOTE:** alternative applications as [youtube-dl](https://github.com/ytdl-org/youtube-dl) and [pytube](https://pytube.io/en/latest/) are now considered to be legacy as discussed in this [post](https://www.reddit.com/r/Python/comments/18wzsg8/good_pytube_alternative/).

### Installing Python packages behind proxy

#programming/python/tips 

To install a package behind a proxy requiring SSL one can enforce trusted hosts to avoid certificate hand-shake and allow installation. This is done with the following options:

```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <pkg>
```

### Extracting text from PDF

Provides reference text exported from PDF files. 

The engine uses a combination of [tesseract](https://github.com/tesseract-ocr/tesseract) and [PyPDF2](https://github.com/mstamy2/PyPDF2) to perform the data extraction. Nonetheless, human curation of extracted texts is still required if readability is a requirement. If quality of automated extractions is often poor for a specific language, you might want to search the web how to *train tesseract*, that topic is not covered here.

Besides Python you will need:

- Tesseract (and a language pack) for extracting text from PDF.
- ImageMagick for image conversion.
- Poppler utils for PDF conversion

Install dependencies on Ubuntu 22.04:

```bash
sudo apt install  \
    tesseract-ocr \
    imagemagick   \
    poppler-utils
```

In case of Rocky Linux 9:

```bash
sudo dnf install           \
    tesseract              \
    tesseract-langpack-eng \
    ImageMagick            \
    poppler-utils
```

For Windows you will need to manually download both `tesseract` and `poppler` and place them somewhere in your computer. The full paths to these libraries and/or programs is provided by the optional arguments `tesseract_cmd` and `poppler_path` of `Convert.pdf2txt`.

Create a local environment, activate it, and install required packages:

```bash
python3 -m venv venv

source venv/bin/activate
    
pip install              \
    "pdf2image==1.17.0"  \
    "pillow==11.0.0"     \
    "PyPDF2==3.0.1"      \
    "pytesseract==0.3.13"
```

Now you can use the basic module [`pdf_convert`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/src/py/pdf_convert.py) provided here.

### Regular expressions

Regular expressions (or simply *regex*) processing is a must-have skill for anyone doing scientific computing. Most programs produce results or logs in plain text and do not support specific data extraction from those. There *regex* becomes your best friend. Unfortunately during the years many flavors of regex appeared, each claiming to offer advantages or to be more formal than its predecessors. Due to this, learning regex is often language-specific (most of the time you create and process regex from your favorite language) and sometimes even package-specific. Needless to say, regex may be more difficult to master than assembly programming.

#### Useful tools

- [regex101](https://regex101.com/)
- [regexr](https://regexr.com/).

#### Matching between two strings

Match [all characters between two strings](https://stackoverflow.com/questions/6109882/regex-match-all-characters-between-two-strings) with lookbehind and look ahead patterns. Notice that this will require the enclosing strings to be fixed (at least under PCRE). For processing `WallyTutor.jl` documentation I have used a [more generic approach](https://github.com/wallytutor/WallyToolbox.jl/blob/89603a88d54eed1d15b9f8142640ef942cfa12ca/docs/formatter.jl#L20) but less general than what is proposed [here](https://stackoverflow.com/questions/14182879/regex-to-match-latex-equations).

#### Match any character across multiple lines

Match [any character across multiple lines](https://stackoverflow.com/questions/159118) with `(.|\n)*`.

#### Regex in Julia

Currently joining regexes in Julia might be tricky (because of escaping characters); a solution is proposed [here](https://stackoverflow.com/questions/20478823/joining-regular-expressions-in-julia) and seems to work just fine with minimal extra coding.
## Working on Windows

### Creating a portable launcher

A simple way to create a portable launcher requiring to source extra variables is by writing a simple batch script exporting or calling another script with the definitions:

```batch
@echo off

@REM Add variables to be sourced here such as
@REM set PATH="/path/to/some/dir";%PATH%
@REM ... or call another shared script doing so.
@REM call %~dp0\env

MyCode.exe
```

Because a batch script will keep a console window open, create a VB file with the following

```vb
Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c MyCode.bat"
oShell.Run strArgs, 0, false
```

In the example we assume the program is called `MyCode.exe` and the batch script has been named in an analogous way `MyCode.bat`.

### Mount a network drive in WSL

Here we assume we will mount drive `Z:` at `/mnt/z`:

```bash
# Create the mount point (if required):
sudo mkdir /mnt/z

# Mount the network drive in WSL:
sudo mount -t drvfs Z: /mnt/z
```

### Following the writing to a file

This is equivalent to Linux `tail -f <file-path>`:

```bash
Get-Content -Path "<file-path>" -Wait
```

### Finding a process handle

This is useful when Windows won't let you move a file or folder because *it is already open somewhere*. First, download and extract [Handle](https://learn.microsoft.com/en-us/sysinternals/downloads/handle); from PowerShell run the following:

```bash
./handle.exe -u -nobanner "C:\Path\To\File.txt"
```

Notice that your file might have started another process and some research might be required.

### Mount SMB under WSL

You can access a SMB drive from within WSL (Ubuntu) temporarily with:

```bash
sudo mount -t drvfs '\\path\to\smb' /mnt/<mount-point>/
```

For automatic remount, consider adding the following to your `/etc/fstab`

```bash
//path/to/smb /mnt/<mount-point>/ drvfs auto,rw,nosuid,exec,uid=1000,gid=1000 0 0
```

## Working on Linux

### SSH key generation

#### Creating the keys

Generate the SSH key pair locally (*i.e.* on your workstation); common options are:

- `-t rsa`: key type (RSA is widely supported)  
- `-b 4096`: key length (more bits = stronger, recommended 4096) 
- `-C` : comment (usually your email)

When running the command, accept defaults for storage at `~/.ssh/id_rsa[.pub]`; optionally add a passphrase for additional security (but then you will need to enter it each time you need to connect, so that's undesirable if the only reason you are creating the SSH key is to have quick access to the server).

```bash
ssh-keygen -t rsa -b 4096 -C "yourusername@your.server.com"
ssh-keygen -t ed25519 -b 4096 -C "yourusername@your.server.com"
```

If you have password access to the server and `ssh-copy-id` run the following:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote_host
```

Alternatively (in Windows PowerShell for instance but reformat it in a single line or replace the pipes by backticks) manually append to the `~/.ssh/authorized_keys`:

```bash
cat ~/.ssh/id_rsa.pub | \
    ssh yourusername@your.server.com \
    "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

As a last option do it by hand, but you risk breaking the format of `authorized_keys`.

#### Testing Linux server

Before anything, try connecting with you identity:

```bash
ssh -i ~/.ssh/id_rsa yourusername@your.server.com
```

If that falls-back to your password connection, connect normally to the server and make sure the rights of both SSH directory and authorized keys file are right before trying again:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Maybe the server SSH has not been enabled for key authentication, which can be inspected without opening the actual configuration file through (requires `sudo` rights):

```bash
sudo sshd -T | grep pubkeyauthentication
```

If it is not enabled, you can edit the file (find and modify `PubkeyAuthentication yes`) as follows and restart the service:

```bash
sudo vim /etc/ssh/sshd_config
sudo systemctl restart sshd

# Additional step for SELinux only:
restorecon -Rv ~/.ssh
```

Test again; upon new failure, try the verbose mode of SSH connection on your workstation:

```bash
ssh -v yourusername@your.server.com
```

while simultaneously connected to the server (`sudo`) reading the logs:

```bash
# Debian-based:
sudo tail -f /var/log/auth.log

# Under RHEL/CentOS/Fedora:
sudo tail -f /var/log/secure
```

#### Adding the key to VS Code

- Install `Remote-SSH` extension
- Press `F1` and search for `Remote-SSH: Open SSH Configuration File`
- Add an entry like the following (modifying the host name and user):

```
Host myserver
    HostName your.server.com
    User yourusername
    IdentityFile ~/.ssh/id_rsa
```

### Gnome 3

Several recent Linux distributions use Gnome 3 as the default desktop manager. A few *innovations* introduced by this environment are not really interesting and falling back to classical modes is useful:

- [Add minimize/maximize buttons to the corner of windows](https://askubuntu.com/questions/651347)
- [Include a permanent configurable dock for applications](https://micheleg.github.io/dash-to-dock/)

### Creating an AppImage installer

An *AppImage* application is a bundle intended to be portable across many distributions. Its main inconvenient is that you manually need to give execution permissions and launch it from command line every time. 

The following snippet is aimed to automating an *AppImage* installation under Gnome 3. Simply replace the fields marked by `<something>` with the required names and run the script (requires admin rights).

```bash
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

### FTPS server configuration

```bash
sudo dnf install -y vsftpd
```

```bash
sudo vim /etc/vsftpd/vsftpd.conf
```

```ini
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
```

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/certs/vsftpd.pem                  \
	-out /etc/ssl/certs/vsftpd.pem
```

```ini
rsa_cert_file=/etc/ssl/certs/vsftpd.pem
rsa_private_key_file=/etc/ssl/certs/vsftpd.pem
```

```ini
chroot_local_user=YES
allow_writeable_chroot=YES
```

```bash
sudo systemctl enable vsftpd
sudo systemctl restart vsftpd
sudo systemctl status vsftpd
```

```bash
sudo firewall-cmd --permanent --add-service=ftp
sudo firewall-cmd --permanent --add-port=990/tcp
sudo firewall-cmd --reload
```


## Fresh Ubuntu

This document provides the basic steps to setup a working Ubuntu system for scientific computing. It includes the general setup and customization steps. For more on #linux, please visit the dedicated [page](linux.md).

### Getting started

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

### Mount a NTFS drive

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

### Version control

Install `git` (and `gh` if using GitHub) and configure credentials:

```bash
sudo apt install git gh

git config --global user.email "walter.dalmazsilva@gmail.com"
git config --global user.name "Walter Dal'Maz Silva"

# (optional)
gh auth login
```

### Scientific computing

- Install a good editor such as [Zed](https://zed.dev/download) or [VS Code](https://code.visualstudio.com/download).

- Minimum set for editing, retrieving data, and containerizing:

```bash
sudo apt install btop neovim curl terminator podman
```

- Minimum set for using system's built-in Python useful:

```bash
sudo apt install python3-pip python3-venv
```

- Install Octave programming language:

```bash
sudo apt install octave
```

- Install [Julia](https://julialang.org/downloads/) programming language:

```bash
curl -fsSL https://install.julialang.org | sh
```

- Install [Rust](https://www.rust-lang.org/tools/install) programming language:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- Install the whole of TeXLive and pandoc:

```bash
sudo apt install texlive-full pandoc
```

- For containers (`podman`, `apptainer`), consider checking [this page](../containers/README.md).

### Personal configuration

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

4. Download `.deb` packages of Edge, Chrome, Obsidian and Zettlr.
5. Once Edge and/or Chrome is available, `sudo apt remove snapd`.
6. Productivity tools I use in graphical environments:

```bash
sudo apt install texstudio jabref
```

7. Add user applications folder to `.bashrc`:

```bash
function extra_sources() {
    source "$HOME/.cargo/env"
}

function extra_paths() {
    export PATH=$HOME/.local/bin:$PATH

    if [ -d ~/Applications ]; then
        for extrapath in ~/Applications/*; do
            export PATH="$extrapath:$PATH"
        done
    fi

    unset extrapath
}

extra_sources
extra_paths
```

8. Other `.bashrc` customization:

```bash
function build_image() {
    podman build -t $1 -f $2 .
}

function run_container() {
    podman run -it $1 /bin/bash
}

function openfoam12() {
	FOAM_NAME=$HOME/Applications/openfoam12-rockylinux9
	apptainer run --cleanenv --env-file ${FOAM}.env ${FOAM}.sif
}
```

### Limiting CPU frequency

Management of CPU frequency can be done through `cpufrequtils`; sometimes it will only work if cores are set individually (with flag `-c` to specify the zero-based core number).

```bash
# Check before:
cpufreq-info

# Modify bounds:
cpufreq-set -c <i> -u 2.5GHz
...

# Check after:
cpufreq-info
```

## LaTeX

### Math typesetting with LaTeX

- For integrals to display the same size as fractions expanded with `\dfrac`, place a `\displaystyle` in front of the `\int` command.

### Code typesetting with LaTeX

- For some reason `minted` blocks `\begin{minted}...\end{minted}` have problems to render in Beamer (something related to multilevel macros). I managed to insert code blocks with `\inputminted` as reported [here](https://tex.stackexchange.com/questions/159667/including-python-code-in-beamer).

- Beamer have some issues with footnotes, especially when use `column` environments; a quick fix for this is through `\footnotemark` and `\footnotetext[<number>]{<text>}` as described [here](https://tex.stackexchange.com/questions/86650/how-to-display-the-footnote-in-the-bottom-of-the-slide-while-using-columns). Notice that `\footnotemark` automatically generates the counter for use as `<number>` in `\footnotetext`.

- For setting a background watermark in Beamer one can use package `background` and display it using a Beamer template as described [here](https://tex.stackexchange.com/questions/244091/watermark-using-background-package-in-beamer).

### MiKTeX

- [mathkerncmssi source file could not be found](https://tex.stackexchange.com/questions/553716/mathkerncmssi-source-file-could-not-be-found)

- [Installing user packages and classes](https://docs.miktex.org/manual/localadditions.html)

### LaTeX Workshop

- [Configuring builds in VS Code with LaTeX Workshop](https://tex.stackexchange.com/questions/478865/vs-code-latex-workshop-custom-recipes-file-location) for building with `pdflatex`. Finally I ended creating my own workflows in this [file](https://github.com/wallytutor/WallyToolbox.jl/blob/main/tools/vscode/user-data/User/settings.json).

## Visual Studio Code

### Basics

If you are reading this, you are probably using [VS Code](https://code.visualstudio.com/) for the first time or need a refresher! VS Code is Microsoft's open source text editor that has become the most popular editor in the past decade. It is portable (meaning it works in Windows, Linux, and Mac) and relatively light-weight (it won't use all you RAM as some proprietary tools would do). There are a few shortcuts you might want to keep in mind for using this tool in an efficient manner:

- `Ctrl+J`: show/hide the [terminal](cli.md)
- `Ctrl+B`: show/hide the project tree
- `Ctrl+Shift+V`: display this file in rendered mode
- `Ctrl+Shift+P`: access the command pallet
- `Ctrl+K Ctrl+T`: change color theme
- `Alt+Z`: toggle column wrapping

A few more tips concerning the terminal:

- `Ctrl+L` gives you a clean terminal (also works inside Julia prompt)
- `Ctrl+D` breaks a program execution (*i.e.* use to quit Julia prompt)

If you copied a command from a tutorial, you **CANNOT** use `Ctrl+V` to paste it into the terminal; in Windows simply right-click the command prompt and it will paste the copied contents. Linux users can `Ctrl+Shift+V` instead.

Notice that `Ctrl+M` will toggle the visibility of the integrated terminal; if you accidentally press it, autocompletion will stop working in terminal. Just press it again and normal behavior will be recovered.

### Extensions

VS Code supports a number of extensions to facilitate coding and data analysis, among other tasks. Local (user-created) extensions can be manually installed by placing their folder under `%USERPROFILE%/.vscode/extensions` or in the equivalent directory documented [here](https://code.visualstudio.com/docs/editor/extension-marketplace#_where-are-extensions-installed). Below you find my recommended extensions for different purposes and languages.

#### Julia

- [Julia](https://github.com/julia-vscode/julia-vscode)
- [Julia Color Themes](https://github.com/CameronBieganek/julia-color-themes)

#### Personal

I have also developed a few (drag-and-drop) extensions; in the future I plan to provided them through the extension manager.

- [wallytutor/elmer-sif-vscode: VS Code extension for Elmer Multiphysics SIF](https://github.com/wallytutor/elmer-sif-vscode)

## Git

### Version control in Windows

- [TortoiseGIT](https://tortoisegit.org/): for Windows users, this applications add the possibility of managing version control and other features directly from the file explorer.

### Creating gh-pages branch

To create a GitHub pages branch with no history do the following

```bash
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "fresh and empty gh-pages branch"
git push origin gh-pages
```

### Adding submodules

Generally speaking adding a submodule to a repository should be a simple matter of

```bash
git submodule add https://<path>/<to>/<repository>
```

Nonetheless this might fail, especially for large sized repositories; I faced [this issue](https://stackoverflow.com/questions/66366582) which I tried to fix by increasing buffer size as reported in the link. This solved the issue but led me to [another problem](https://stackoverflow.com/questions/59282476) which could be solved by degrading HTTP protocol.

The reverse operation cannot be fully automated as discussed [here](https://stackoverflow.com/questions/1260748). In general you start with

```bash
git rm <path-to-submodule>
```

and then manually remove the history with

```bash
rm -rf .git/modules/<path-to-submodule>

git config remove-section submodule.<path-to-submodule>
```

### Line ending normalization

Instructions provided in [this thread](https://stackoverflow.com/questions/2517190); do not forget to add a `.gitattributes` file to the project with `* text=auto` for checking-in files as normalized. Then run the following:

```bash
git add --update --renormalize
```

## Containers

### Using Podman

In the open source community [podman](https://podman.io/) takes the place of [docker](https://www.docker.com/) for the creation of application containers. It mimics the commercial software to allow developers work with both tools *almost* interchangeably. It is not uncommon to find people creating aliases of `docker` in their sandbox environments to point to their `podman` executable (some Linux distributions even have packages dedicated to this automatic override). One must be aware that although the command interfaces are very similar, they are not the *exactly* same and advance usage requires mastering each of them individually.

The following summarizes some daily life commands with `podman`.

- List available images in a local machine:

```bash
podman images
```

- Run image `<img>` interactively using bash:

```bash
podman run -it <img> /bin/bash
```

- Run image exposing port `<container>` to host at `<host>`:

```bash
podman run -p <container>:<host> <img>
```

- Dump image `<img>` to `<img>.tar` for portability:

```bash
podman save -o <img>.tar <img>
```

- List all available containers (there might be external/hidden, so use `-a`):

```bash
podman container ls -a
```

- Remove a given container by ID (only the first 2-3 characters of ID are required):

```bash
podman container rm <ID>
```

- Remove a given image by ID:

```bash
podman rmi <ID>
# podman image rm <ID>
```

### Using Apptainer

Using `podman` locally is great, but packaging redistributable containers for reuse in HPC is much smoother with [Apptainer](https://apptainer.org/). The tool started at [Lawrence Berkeley National Laboratory](https://www.lbl.gov/) can be [downloaded](https://github.com/apptainer/apptainer/releases) for several Linux systems and deployed locally.

Under Debian (or its variants, as Ubuntu), navigate to the download directory and install with the following, taking care to replace the right version:

```shell
export APPTAINER_VERSION=1.3.6_amd64.deb

sudo dpkg -i apptainer_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-dbgsym_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid-dbgsym_${APPTAINER_VERSION}
```

- Converting a local `podman` *tar-dump* into a Singularity image:

```bash
apptainer build "<img>.sif" "docker-archive://<img>.tar"
```

- Running an `apptainer` image as a non-root user is as simple as:

```bash
apptainer run <img>.sif
```

Although Apptainer has its own image scripting system through [*definition files*](https://apptainer.org/docs/user/latest/definition_files.html), personal experience has shown that the workflow is much smoother by generating container files and then converting them to Singularity format as explained above.

There reason is that container files generate intermediate check-points from which they will continue the build if some failure is encountered, *i.e.* each `RUN` command in a container will generate a partial image.

When working with Apptainer definition files, failures imply full rebuild of the image, what might become extremely boring when trying to compile new code. A workaround is to use a sequence of definition files, one importing from the dump of the previous one, but that not only will generate a large size of temporary dumps as it will become difficult to manage.

After getting excited by the Apptainer definition files because they do not need chaining of commands with a `&& \` to make a shell block, I personally gave up on them after loosing a few days of my life recompiling again and again... so for now I stick with the container creation and conversion workflow discussed in more detail below.

### Apptainer and environment

Since `apptainer` makes use of *user space*, sourcing of applications is not done as root, so one must edit add to their `~/.bashrc` if path configuration is desired and re-source that file when activating a container. For instance, the required environment variables for #OpenFOAM are provided `FOAM_SOURCE` file given below; in the *host system* outside the container it does not exist, so adding a test in `~/.bashrc` is required. Once you activate the container with `apptainer run <image-name>.sif`, by calling `source ~/.bashrc` the environment will be properly set.

```bash
FOAM_SOURCE=/opt/openfoam12/OpenFOAM-12/etc/bashrc

[[ -f ${FOAM_SOURCE} ]] && source ${FOAM_SOURCE}
```

Another approach is to execute the SIF image once, source the required variables required in the container, dump `env > draft.env`, [edit the file](https://github.com/wallytutor/learning-by-teaching/blob/main/containers/clean-env.py) as required and then wrap a call with contextualized environment as:

```bash
function openfoam12() {
    FOAM_NAME=$HOME/Applications/openfoam12-rockylinux9
    apptainer run --cleanenv --env-file ${FOAM}.env ${FOAM}.sif
}
```

### Build workflow

Using both tools can be roughly automated by generating a `podman` image, dumping it into a portable format, then converting to Singularity format. Below we illustrate the workflow for [this OpenFOAM Containerfile](https://github.com/wallytutor/learning-by-teaching/blob/main/software/containers/Containerfile-rockylinux9-openfoam12):

```bash
# Variable with name of container:
R9OF12=rockylinux9-openfoam12

# Avoid the following warning:  WARN[0000] "/" is not a shared mount, this
# could cause issues or missing mounts with rootless containers.
sudo mount --make-rshared /

# Build the container image:
/usr/bin/podman build -t "${R9OF12}" -f "Containerfile-${R9OF12}" .

# Save container to portable .tar:
/usr/bin/podman save -o "${R9OF12}.tar" "localhost/${R9OF12}"

# Convert container to
/usr/bin/apptainer build "${R9OF12}.sif" "docker-archive://${R9OF12}.tar"

# After making sure it is working, remove the image:
/usr/bin/podman rmi "${R9OF12}"
```

Now you can move the SIF image to another computer (for instance, you prepared this in a PC with access to the Internet to later use it in an isolated HPC), open a new terminal or `source ~/.bashrc` and run:

```bash
apptainer run -B $PWD /<path>/<to>/openfoam12-rockylinux9.sif
```

**Note:** use `apptainer run` when you want to execute the container's default application or task; on the other hand, use `apptainer shell` when you need an interactive session to explore or debug the container. For the OpenFOAM example above, both are very similar as no default application is launched, but a shell session itself.
