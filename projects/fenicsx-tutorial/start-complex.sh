#!/usr/bin/env bash

. /usr/local/bin/dolfinx-complex-mode
. /usr/local/dolfinx-complex/lib/dolfinx/dolfinx.conf

jupyter lab --ip=0.0.0.0 --no-browser
