# Ansys Fluent


## License usage

```shell
export LMUTIL=/<path-to-ansys>/ansys_inc/<version>/licensingclient/linx64/lmutil
"${LMUTIL}" lmstat -c 1055@<ip> -a | grep "Users of" | \
    awk -F'[ ]' '{printf "%-25s %3s /%3s\n", $3, $13, $7}'
```

## Text user interface (TUI)

```scheme
; This is a comment (starting by a semi-colon).
/file/read-case "domain/tunnel.msh.h5" yes

/mesh/check
/mesh/mesh-info 0
```

```scheme
/define/named-expressions/add "diam"  definition "0.01 [m]"       parameter yes ()
/define/named-expressions/add "dens"  definition "1.29 [kg/m^3]"  parameter no  ()
/define/named-expressions/add "visc"  definition "1.84 [Pa*s]"    parameter no  ()
/define/named-expressions/add "theta" definition "25 [deg]"       parameter no  ()
```

```scheme
/define/operating-conditions/gravity yes 
    "0 [m/s^2]"
    "-cos(theta) * 9.81 [m/s^2]"
    "-sin(theta) * 9.81 [m/s^2]"
```

```scheme
/define/models/viscous/ke-realizable yes
/define/models/dpm/interaction/coupled-calculations yes
```

```scheme
/define/materials/change-create "air" "air" 
    yes expression "dens" no no yes expression "visc" no no no
```

```scheme
/define/boundary-conditions/set/mass-flow-inlet 
    "inlet"  () mass-flow no 1.0  ()
    
/define/boundary-conditions/set/mass-flow-inlet 
    "inlet"  () mass-flow no "mdot_inlet"  ()
```

```scheme
/file/write-case "model-setup.cas.h5" yes
```

```scheme
/solve/initialize/initialize-flow
/solve/initialize/hyb-initialization yes
/file/write-case-data "model-initialized.cas.h5" yes
```

```scheme
/solve/iterate 100
```

```scheme
; XXX: notice that shape factor for nonspherical particles cannot be set from
; TUI, you must provide the value of 0.077 at the GUI

; /define/models/dpm/injections/create-injection/fibers
; Particle type [inert]: Change current value? [no] 
; Injection type [single]: Change current value? [no] yes
; Injection type [single]> surface
; Injection Material [anthracite]: Change current value? [no] 
; Surface(1) [()] injection
; Surface(2) [()] ()
; Scale Flow Rate by Face Area [no] no
; Use Face Normal for Velocity Components [no] yes
; Stochastic Tracking? [no] yes
; Random Eddy Lifetime? [no] yes
; Number of Tries [1] 
; Time Scale Constant [0.15] 
; Modify Laws? [no] 
; Set user defined initialization function? [no] 
; Cloud Tracking? [no] 
; Rosin Rammler diameter distribution? [no] 
; Diameter (in [m]) [0.0001] 0.000976
; Velocity Magnitude (in [m/s]) [0] 20
; Total Flow Rate (in [kg/s]) [9.999999999999999e-21] 0.027777777777777776
/define/models/dpm/injections/create-injection/fibers 
    no yes surface no injection () no yes yes 
    yes 1 0.15 no no no no 0.000976 20 0.028 

/define/materials/change-create/anthracite "fibers" yes constant 2800 no yes
```

```scheme
/solve/report-definitions/delete-all yes

/solve/report-definitions/add/mass-flows surface-massflowrate
surface-names
"injection-1"
"injection-2"
"extractions" ()
per-surface yes ()

/solve/report-files/add/report-mass-flows 
file-name "report-mass-flows-rfile.out"
report-defs "mass-flows" () ()

```

```scheme
; /parallel/check
; /parallel/partition/auto
; /parallel/timer/usage
```

## Getting started with PyFluent

- [Intro to PyFluent](https://www.youtube.com/playlist?list=PLtt6-ZgUFmMIm19SaqN_A4wGrISjEoHdd)
- [PyFluent documentation](https://fluent.docs.pyansys.com/)

Install sequentially the following packages as described [here]([https://www.youtube.com/watch?v=uctVdFYvuYg&list=PLtt6-ZgUFmMIm19SaqN_A4wGrISjEoHdd&index=4):

```shell
pip install ansys-fluent-core
pip install ansys-fluent-parametric
pip install ansys-fluent-visualization
```

**Note:** `ansys-fluent-parametric` requires an outdated version of NumPy (<2.0), so you probably need to consider working in a virtual environment.

Base steps to start building an image from a local install:

```bash
python copy_docker_files.py /home_nfs/_APPS/ansys_inc/
podman build -t ansys_inc fluent_242/
```

### Journaling

```scheme
(api-start-python-journal "journal.py")
```

### First steps

```python
import ansys.fluent.core as pyfluent
```

```python
config = dict(
    ui_mode   = 'gui',
    precision = 'double',
    dimension = 3,
    processor_count = 1,
)
session = pyfluent.launch_fluent(mode = 'solver', **config)
```

```python
session.exit()
```
