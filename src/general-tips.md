# General Tips

## Running Jupyterlab from a server

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
# Notice that the ports below must be specified as:
# ssh -L <local_port>:localhost:<remote_port> <REMOTE_USER>@<REMOTE_HOST>
ssh -L 8080:localhost:8080 <REMOTE_USER>@<REMOTE_HOST>
```

Now you can browse to `http://localhost:8080/` and add the token you copied earlier or your user-token you added to the configuration file. Notice that you need to keep the terminal you used to launch the port forwarding open while you work.

## Downloading from YouTube

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

## Installing Python packages behind proxy

#programming/python/tips 

To install a package behind a proxy requiring SSL one can enforce trusted hosts to avoid certificate hand-shake and allow installation. This is done with the following options:

```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org <pkg>
```

## Extracting text from PDF

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

## Regular expressions

Regular expressions (or simply *regex*) processing is a must-have skill for anyone doing scientific computing. Most programs produce results or logs in plain text and do not support specific data extraction from those. There *regex* becomes your best friend. Unfortunately during the years many flavors of regex appeared, each claiming to offer advantages or to be more formal than its predecessors. Due to this, learning regex is often language-specific (most of the time you create and process regex from your favorite language) and sometimes even package-specific. Needless to say, regex may be more difficult to master than assembly programming.

Useful tools:

- [regex101](https://regex101.com/)
- [regexr](https://regexr.com/)

**Matching between two strings:** match [all characters between two strings](https://stackoverflow.com/questions/6109882/regex-match-all-characters-between-two-strings) with lookbehind and look ahead patterns. Notice that this will require the enclosing strings to be fixed (at least under PCRE). For processing `WallyTutor.jl` documentation I have used a [more generic approach](https://github.com/wallytutor/WallyToolbox.jl/blob/89603a88d54eed1d15b9f8142640ef942cfa12ca/docs/formatter.jl#L20) but less general than what is proposed [here](https://stackoverflow.com/questions/14182879/regex-to-match-latex-equations).

**Match any character across multiple lines:** as described [here](https://stackoverflow.com/questions/159118) with `(.|\n)*`.

**Regex in Julia:** currently joining regexes in Julia might be tricky (because of escaping characters); a solution is proposed [here](https://stackoverflow.com/questions/20478823/joining-regular-expressions-in-julia) and seems to work just fine with minimal extra coding.

## SSH key generation

**Creating the keys:** generate the SSH key pair locally (*i.e.* on your workstation); common options are:

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

**Testing Linux server:** before anything, try connecting with you identity:

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

**Adding the key to VS Code** by perform the following steps:

- Install `Remote-SSH` extension
- Press `F1` and search for `Remote-SSH: Open SSH Configuration File`
- Add an entry like the following (modifying the host name and user):

```
Host myserver
    HostName your.server.com
    User yourusername
    IdentityFile ~/.ssh/id_rsa
```

If the above fails to fill in your right user name (sometimes Windows username will appear) you can try the following workaround to enforce user:

```bash
Host yourusername@your.server.com
    HostName your.server.com
    User yourusername
    IdentityFile ~/.ssh/id_rsa
```

**About cluster usage:** that is the single case you might want to store both public and private keys at the same `.ssh`; to navigate across nodes (assuming your `$HOME` directory is the same) you need both keys. Please keep in mind to use a different key pair than the one you use to connect to the cluster for security reasons.
