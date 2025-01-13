# General Tips

## Downloading from YouTube

Retrieving a video or playlist from YouTube can be automated with help of [youtube-dl](https://github.com/ytdl-org/youtube-dl).

## Installing Python packages behind proxy

To install a package behind a proxy requiring SSL one can enforce trusted hosts to avoid certificate hand-shake and allow installation. This is done with the following options:

```shell
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

```shell
sudo apt install  \
    tesseract-ocr \
    imagemagick   \
    poppler-utils
```

In case of Rocky Linux 9:

```shell
sudo dnf install           \
    tesseract              \
    tesseract-langpack-eng \
    ImageMagick            \
    poppler-utils
```

For Windows you will need to manually download both `tesseract` and `poppler` and place them somewhere in your computer. The full paths to these libraries and/or programs is provided by the optional arguments `tesseract_cmd` and `poppler_path` of `Convert.pdf2txt`.

Create a local environment, activate it, and install required packages:

```shell
python3 -m venv venv

source venv/bin/activate
    
pip install              \
    "pdf2image==1.17.0"  \
    "pillow==11.0.0"     \
    "PyPDF2==3.0.1"      \
    "pytesseract==0.3.13"
```

Now you can use the basic module [`pdf_convert`](https://github.com/wallytutor/WallyToolbox.jl/blob/main/src/py/pdf_convert.py) provided here.
