---
jupyter:
  jupytext:
    formats: md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.16.7
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# PyFluent - Getting started

<!-- #region -->
## Resources

- [Intro to PyFluent](https://www.youtube.com/playlist?list=PLtt6-ZgUFmMIm19SaqN_A4wGrISjEoHdd)
- [PyFluent documentation](https://fluent.docs.pyansys.com/)

## Installation

Install sequentially the following packages as described [here]([https://www.youtube.com/watch?v=uctVdFYvuYg&list=PLtt6-ZgUFmMIm19SaqN_A4wGrISjEoHdd&index=4):

```shell
pip install ansys-fluent-core
pip install ansys-fluent-parametric
pip install ansys-fluent-visualization
```

**Note:** `ansys-fluent-parametric` requires an outdated version of NumPy (<2.0), so you probably need to consider working in a virtual environment.

## Journaling

```scheme
(api-start-python-journal "journal.py")
```
<!-- #endregion -->

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
```

```python
session = pyfluent.launch_fluent(mode = 'solver', **config)
```

```python
session.exit()
```

```python
# ?pyfluent.launch_fluent
```

```python

```

```python

```

```python

```
