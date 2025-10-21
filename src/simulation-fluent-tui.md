# Text user interface (TUI)

## Setup of a case

### Loading and checking a mesh

```scheme
; This is a comment (starting by a semi-colon).
/file/read-case "domain/tunnel.msh.h5" ()
/mesh/check
/mesh/mesh-info 0

; Write the case (or overwrite if existing)
/file/write-case "tunnel-model.cas.h5" ()
```

### Defining and saving named expressions

```scheme
/define/named-expressions/add "diam"  definition "0.01 [m]"       parameter yes ()
/define/named-expressions/add "dens"  definition "1.29 [kg/m^3]"  parameter no  ()
/define/named-expressions/add "visc"  definition "1.84 [Pa*s]"    parameter no  ()
/define/named-expressions/add "theta" definition "25 [deg]"       parameter no  ()
/define/named-expressions/export-to-tsv "expressions.tsv" ()
```

### Defining operating conditions

```scheme
/define/operating-conditions/gravity yes
    "0 [m/s^2]"
    "-cos(theta) * 9.81 [m/s^2]"
    "-sin(theta) * 9.81 [m/s^2]"
```

### Setting up some models

```scheme
; Select a viscous model
/define/models/viscous/ke-realizable yes
/define/models/viscous/kw-sst yes

; Activate DPM calculations
/define/models/dpm/interaction/coupled-calculations yes
/define/models/dpm/interaction/dpm-iteration-interval 10
```

### Modify materials

```scheme
; TODO add comments for each line!
/define/materials/change-create "air" "air"
    yes expression "dens"
    no
    no
    yes expression "visc"
    no
    no
    no
```

### Setting boundary conditions

```scheme
/define/boundary-conditions/set/mass-flow-inlet
    "inlet"  () mass-flow no 1.0  ()

/define/boundary-conditions/set/mass-flow-inlet
    "inlet"  () mass-flow no "mdot_inlet"  ()
```

### Creating a DPM injection

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

### Report definitions

```scheme
/solve/report-definitions/delete-all yes
```

```scheme
/solve/report-definitions/add/mass-flows surface-massflowrate
    surface-names
        "injection-1"
        "injection-2"
        "extractions" ()
    per-surface yes ()

/solve/report-files/add/report-mass-flows
    file-name   "report-mass-flows-rfile.out"
    report-defs "mass-flows" () ()

/solve/report-files/edit/report-mass-flows
    frequency 10 ()
```

```scheme
/solve/report-definitions/add/mass-extraction injection-escaped-mass
    boundary-zones "extraction" () ()
```

## Solution controls

### Residuals

```scheme
/solve/monitors/residual/convergence-criteria
    1e-9 ; continuity residual convergence criterion [0.001]
    1e-6 ; x-velocity residual convergence criterion [0.001]
    1e-6 ; y-velocity residual convergence criterion [0.001]
    1e-6 ; z-velocity residual convergence criterion [0.001]
    1e-5 ; k residual convergence criterion [0.001]
    1e-5 ; omega residual convergence criterion [0.001]
```

### Solver parameters

```scheme
/solve/set/pseudo-time-method global yes 1 1.0 ()

/solve/set/p-v-controls 0.7 0.3
/solve/set/pseudo-time-method/relaxation-factors/density 0.5

/solve/set/discretization-scheme/k        0 ()
/solve/set/discretization-scheme/omega    0 ()
```

### Initialize flow and iterate

```scheme
/solve/initialize/initialize-flow
/solve/initialize/hyb-initialization yes
/solve/iterate 100
```

### Parallel settings

```scheme
; /parallel/check
; /parallel/partition/auto
; /parallel/timer/usage
```

## Postprocessing

```scheme
; Options for view name:

/display/display-states/create state-right
    "disable"      ; Front face transparent ("enable" "disable" "dont-save")
    "orthographic" ; Projection ("perspective" "orthographic" "dont-save")
    "enable"       ; Axes ("enable" "disable" "dont-save")
    "disable"      ; Ruler ("enable" "disable" "dont-save")
    "disable"      ; Title ("enable" "disable" "dont-save")
    "enable"       ; Boundary markers ("enable" "disable" "dont-save")
    "enable"       ; Anti-aliasing ("enable" "disable" "dont-save")
    "disable"      ; Reflections ("enable" "disable" "dont-save")
    "disable"      ; Static shadows ("enable" "disable" "dont-save"
    "disable"      ; Dynamic shadows  ("enable" "disable" "dont-save")
    "disable"      ; Grid plane ("enable" "disable" "dont-save")
    "on"           ; Headlights ("on" "off" "automatic" "dont-save")
    "automatic"    ; Lighting ("automatic" "flat" "gouraud" "phong" "dont-save" "off")
    "right"        ; View name ("active" "dont-save" "wf-view" "front" "back"
                   ;            "right" "left" "top" "bottom" "isometric" "view-0")
    "0"            ; (dont-save 0) ["0"]
```

```scheme
/display/objects/create/mesh wire
    options
        edges? yes
        faces? no ()
    edge-type outline
    coloring uniform edges black ()
    display-state-name state-right ()
```

```scheme
/display/objects/create/contour contour-total-pressure
    surfaces-list "plane-name" ()
    field total-pressure
    range-option autorange-off
        minimum -200
        maximum  200
        clip-to-range? no ()
    color-map
        title-elements "Variable Only"
        color          "field-pressure"
        position       0
        format         "%.0f" ()
    display-state-name state-right ()
```

```scheme
/display/objects/create/scene scene-total-pressure
    graphics-objects
        add  "wire" ()
        add "contour-total-pressure" () ()
    display-state-name state-right ()
```

```scheme
/file/write-case-data "model-final.cas.h5" yes
```
