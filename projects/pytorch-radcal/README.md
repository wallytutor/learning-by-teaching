# Radcal

The goal of this project is to provide a trained model for predicting radiative properties of media as computed from [radcal](https://github.com/firemodels/radcal). It aims at speeding up calculations for use with computational fluid dynamics (CFD) codes.

## Installation

Create an environment, activate it, and install development dependencies. Please notice that you might need to change the value of `--extra-index-url` in [requirements.dev](requirements.dev) to a value matching your CUDA version as described [here](https://pytorch.org/get-started/locally/).

```shell
python -m venv venv

venv/Scripts/Activate.ps1

python -m pip install --upgrade pip

pip install -r requirements.dev
```

To verify the installation you can run the following in a Python console:

```python
import torch

torch.rand(5, 3)

torch.cuda.is_available()
```

## Contents

Launch `jupyter-lab` to be able to execute the following notebooks. Remember to right-click the script name and `Open With > Jupytext Notebook`.

1. [Data generation](prepare.md)
1. Train and test
1. Verification

## Classifiers

#programming/python #programming/pytorch
