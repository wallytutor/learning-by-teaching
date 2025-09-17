# Scripts

## Development

```shell
# Install `virtualenv`:
pip install virtualenv

# Create a local environment:
virtualenv venv

# Alternativelly use built-in:
# python -m venv venv

# Activate the environment:
./venv/Scripts/activate

# Install version controlled requirements:
python -m pip install -r requirements.txt
```

For a full development version simply install the following packages:

```shell
# Explicit requirements list:
pip install \
    branca \
    folium \
    gpxpy \
    numpy \
    pandas \
    pillow \
    pyyaml

# Generate a new requirements.txt:
pip freeze > requirements.txt
```

## Creating content

- For adding new GPX traces to activities, perform the following steps:

    1. Create a new directory under `media` for the activity.
    1. Save the GPX track under that directory with the name `track.gpx`.
    1. Create a `track.yaml` with configurations (copy from an existing directory).
    1. Run `python gpxtohtml.py` to generate the corresponding map.

- For new Via Ferrata tracks, there is a dedicated script `gpxviaferrata.py`.

- For reducing images to a fraction of size for publishing, check `imgresize.py`.
