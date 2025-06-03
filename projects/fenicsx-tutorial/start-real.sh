#!/usr/bin/env bash

. /usr/local/bin/dolfinx-real-mode
. /usr/local/dolfinx-real/lib/dolfinx/dolfinx.conf

jupyter lab --ip=0.0.0.0 --no-browser
