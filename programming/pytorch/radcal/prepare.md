# Data preparation

```python
from enum import Enum
from pathlib import Path
from string import Template
import subprocess
```

```python
RADCAL = "radcal_win_64.exe"
```

```python
TEMP = Path("temp")
TEMP.mkdir(exist_ok=True)
```

```python
SCRIPT = """\
CASE:
&HEADER TITLE="{title}" CHID="{title}" /

&BAND OMMIN = {OMMIN:.16e}
      OMMAX = {OMMAX:.16e} /
      
&WALL TWALL = {TWALL:.2f} /

&PATH_SEGMENT
    T        = {T:.16E}
    LENGTH   = {L:.16E}
    PRESSURE = {P:.16E}
    XCO2     = {CO2:.16E}
    XH2O     = {H2O:.16E}
    XCO      = {CO:.16E}
    XCH4     = {CH4:.16E}
    XC2H4    = {C2H4:.16E}
    XC2H6    = {C2H6:.16E}
    XC3H6    = {C3H6:.16E}
    XC3H8    = {C3H8:.16E}
    XC7H8    = {C7H8:.16E}
    XC7H16   = {C7H16:.16E}
    XCH3OH   = {CH3OH:.16E}
    XMMA     = {MMA:.16E}
    XO2      = {O2:.16E}
    XN2      = {N2:.16E}
    FV       = {FV:.16E} /\
"""
```

```python
def default_kwarg(kwargs, name, value):
    if value is None and name not in kwargs:
        raise ValueError(f"Keyword `{name}` is mandatory!")
        
    if name not in kwargs:
        kwargs[name] = value
```

```python
def normalize_dict(d):
    if (total := sum(d.values())) <= 0.0:
        raise ValueError(f"Non-positive total amount: {total}")

    return {k: v / total for k, v in d.items()}
```

```python
def process_species(**kwargs):
    species = ["CO2", "H2O", "CO", "CH4", "C2H4", "C2H6", "C3H6",
               "C3H8", "C7H8", "C7H16", "CH3OH", "MMA", "N2", "O2"]

    for sname in species:
        default_kwarg(kwargs, sname, 0.0)

    sdict = normalize_dict({k: kwargs[k] for k in species})
    return {**kwargs, **sdict}
```

```python
def generate_script(**kwargs):
    kwargs = process_species(**kwargs)

    default_kwarg(kwargs, "title", "CASE")
    default_kwarg(kwargs, "OMMIN", 50.0)
    default_kwarg(kwargs, "OMMAX", 10000.0)
    default_kwarg(kwargs, "TWALL", None)
    default_kwarg(kwargs, "T",     None)
    default_kwarg(kwargs, "L",     None)
    default_kwarg(kwargs, "P",     None)
    default_kwarg(kwargs, "FV",    0.0)
    
    return SCRIPT.format(**kwargs)
```

```python
def create_script(where, **kwargs):
    path = where / "RADCAL.IN"
    
    with open(path, "w") as fp:
        fp.write(generate_script(**kwargs))

    return path
```

```python
class RadcalReturn(Enum):
    SUCCESS = 1
    CAUTION = 2
    FAILURE = 3
    UNKNOWN = 4
```

```python
def radcal_status(line):
    match line:
        case _ if line.startswith("CAUTION"):
            return RadcalReturn.CAUTION
        case _ if line.startswith("ERROR"):
            return RadcalReturn.FAILURE  
        case _ if line.startswith("CASEID"):
            return RadcalReturn.SUCCESS
        case _:
            return RadcalReturn.UNKNOWN
```

```python
def radcal_parse_line(line):
    key, value = line.split(":")
    value = value.strip("\t").strip()
    return (key, float(value))
```

```python
def radcal_data(fp):
    data = []

    while line := fp.readline():
        if line.startswith(" CALCULATION"):
            break
        
    while line := fp.readline().strip():
        if line.startswith("-"):
            break

        data.append(radcal_parse_line(line))

    return data
```

```python
def radcal_return(where, skip_failure=True):
    if not (path := where / "RADCAL.OUT").exists():
        raise FileNotFoundError(path)
    
    with open(path) as fp:
        line = fp.readline()
        status = radcal_status(line)

        if status == RadcalReturn.UNKNOWN:
            return status, None

        if status != RadcalReturn.SUCCESS and skip_failure:
            return status, None
            
        return status, dict(radcal_data(fp))

    raise ValueError(f"Unknown status: {line}")
```

```python
create_script(TEMP, TWALL=300, T=1000, P=1, L=0.5, CO2=2, H2O=1)
subprocess.run([RADCAL], cwd=TEMP)
radcal_return(TEMP)
```

```python
create_script(TEMP, TWALL=-300, T=1000, P=1, L=0.5, CO2=2, H2O=1)
subprocess.run([RADCAL], cwd=TEMP)
radcal_return(TEMP)
```

```python
create_script(TEMP, TWALL=300, T=1000, P=1, L=0.5, CO2=2, H2O=-1)
subprocess.run([RADCAL], cwd=TEMP)
radcal_return(TEMP)
```
