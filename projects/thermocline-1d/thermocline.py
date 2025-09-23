# -*- coding: utf-8 -*-
# - [x] Cycle
# - [x] Dynamics
# - [x] InOut
# - [x] Measure
# - [x] OrderVerif

# %% TOOLBOX
import numpy as np
import majordome as mj
import matplotlib.pyplot as plt

# %% InOut
def PlotFigure(fileName, xLabel, yLabel, lineLabel, nx, ny, arr):
    """
    Python translation of the Fortran PlotFigure subroutine.

    Parameters
    ----------
    fileName : str
        Name of the output file.
    xLabel, yLabel : str
        Axis labels.
    lineLabel : list of str
        Labels for each line (length nx).
    nx, ny : int
        Dimensions of arr.
    arr : np.ndarray
        Array of shape (nx, ny).
    """

    if nx != arr.shape[0] or ny != arr.shape[1]:
        raise ValueError("arr shape does not match nx, ny")

    with open(fileName, "w") as f:
        # Write axis labels
        f.write(f"{xLabel} {yLabel}\n")

        # Write line labels
        f.write(" ".join(lineLabel) + "\n")

        # Write data
        for j in range(ny):
            row = " ".join(f"{arr[i, j]:17.10E}" for i in range(nx))
            f.write(row + "\n")

def VisualTemp(nCells, Temp_f, Temp_s, MMS,
               PlotFigure,
               manSol_f=None, manSol_s=None,
               height=None):
    """
    Python/Numpy translation of the Fortran VisualTemp subroutine.

    Parameters
    ----------
    nCells : int
        Number of cells.
    Temp_f, Temp_s : np.ndarray
        Fluid and solid temperature arrays.
    MMS : bool
        Manufactured solution flag.
    PlotFigure : callable
        Function to write/plot results.
    manSol_f, manSol_s : np.ndarray, optional
        Manufactured solution arrays (required if MMS=True).
    height : float
        Domain height.
    """

    dx = height / nCells

    if MMS:
        if manSol_f is None or manSol_s is None:
            raise ValueError("manSol_f and manSol_s must be provided when MMS=True")

        # Build array for fluid: x, manSol_f, Temp_f
        x = (np.arange(nCells) + 0.5) * dx
        solArr = np.zeros((3, nCells))
        solArr[0, :] = x
        solArr[1, :] = manSol_f
        solArr[2, :] = Temp_f
        labels = ["x_i", "manSol", "appSol"]
        PlotFigure("Temp_f.dat", "height", "temperature", labels, 3, nCells, solArr)

        # Reuse solArr for solid: x, manSol_s, Temp_s
        solArr[1, :] = manSol_s
        solArr[2, :] = Temp_s
        PlotFigure("Temp_s.dat", "height", "temperature", labels, 3, nCells, solArr)

    else:
        # Build array for fluid: x, Temp_f
        x = (np.arange(nCells) + 0.5) * dx
        solArr = np.zeros((2, nCells))
        solArr[0, :] = x
        solArr[1, :] = Temp_f
        labels = ["x_i", "appSol"]
        PlotFigure("Temp_f.dat", "height", "temperature", labels, 2, nCells, solArr)

        # Reuse solArr for solid: x, Temp_s
        solArr[1, :] = Temp_s
        PlotFigure("Temp_s.dat", "height", "temperature", labels, 2, nCells, solArr)


# %% Cycle
def VisualMotion(nCells, Temp_c, Temp_d, duration,
                 height, dt,
                 EvolveTemp, PointImplicitMethod, PlotFigure):
    """
    Python/Numpy translation of the Fortran VisualMotion subroutine.

    Parameters
    ----------
    nCells : int
        Number of cells.
    Temp_c : float
        Charging (hot) fluid inlet temperature.
    Temp_d : float
        Reference (dead) temperature.
    duration : array-like of length 4
        Durations of [charge, idle_1, discharge, idle_2] phases.
    height : float
        Domain height.
    dt : float
        Time step size.
    EvolveTemp : callable
        Function to evolve temperatures (Temp, nCells, Temp_in, phase, charge, MMS, ...).
    PointImplicitMethod : callable
        Function to couple fluid and solid temperatures.
    PlotFigure : callable
        Function to plot results.
    """
    dx = height / nCells

    # Initialize fluid and solid temperatures to Temp_d
    Temp_f = np.full(nCells, Temp_d)
    Temp_s = np.full(nCells, Temp_d)

    # Arrays to store snapshots: shape (5, nCells)
    stgArr_f = np.zeros((5, nCells))
    stgArr_s = np.zeros((5, nCells))

    # --- Charging phase ---
    time = 0.0
    while time < duration[0]:
        Temp_f = EvolveTemp(Temp_f, nCells, Temp_c, "fluid", "charge", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "charge", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt
    x = (np.arange(nCells) + 0.5) * dx
    stgArr_f[0, :] = x
    stgArr_f[1, :] = Temp_f
    stgArr_s[0, :] = x
    stgArr_s[1, :] = Temp_s

    # --- Idling phase 1 ---
    time = 0.0
    while time < duration[1]:
        Temp_f = EvolveTemp(Temp_f, nCells, 0.0, "fluid", "idling", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "idling", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt
    stgArr_f[2, :] = Temp_f
    stgArr_s[2, :] = Temp_s

    # --- Discharging phase ---
    time = 0.0
    while time < duration[2]:
        Temp_f = EvolveTemp(Temp_f, nCells, Temp_d, "fluid", "dischg", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "dischg", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt
    stgArr_f[3, :] = Temp_f
    stgArr_s[3, :] = Temp_s

    # --- Idling phase 2 ---
    time = 0.0
    while time < duration[3]:
        Temp_f = EvolveTemp(Temp_f, nCells, 0.0, "fluid", "idling", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "idling", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt
    stgArr_f[4, :] = Temp_f
    stgArr_s[4, :] = Temp_s

    # Labels
    labels = ["height", "charge", "idle_1", "dischg", "idle_2"]

    # Plot results
    PlotFigure("Motion_f.dat", "height", "temperature", labels, 5, nCells, stgArr_f)
    PlotFigure("Motion_s.dat", "height", "temperature", labels, 5, nCells, stgArr_s)


def CompareExSol(nCells, Temp_c, Temp_d, duration,
                 height, dt,
                 EvolveTemp, PointImplicitMethod, PlotFigure):
    """
    Python/Numpy translation of the Fortran CompareExSol subroutine.

    Parameters
    ----------
    nCells : int
        Number of cells.
    Temp_c : float
        Charging (hot) inlet temperature.
    Temp_d : float
        Reference (dead) temperature.
    duration : array-like of length 4
        Durations of [charge, idle_1, discharge, idle_2] phases.
    height : float
        Domain height.
    dt : float
        Time step size.
    EvolveTemp : callable
        Function to evolve temperatures (Temp, nCells, Temp_in, phase, charge, MMS, ...).
    PointImplicitMethod : callable
        Function to couple fluid and solid temperatures.
    PlotFigure : callable
        Function to plot results.
    """

    dx = height / nCells

    # Initialize fluid and solid temperatures to Temp_d
    Temp_f = np.full(nCells, Temp_d)
    Temp_s = np.full(nCells, Temp_d)

    # Labels
    labels = ["height", "fluid", "solid"]

    # --- Charging phase ---
    time = 0.0
    while time < duration[0]:
        Temp_f = EvolveTemp(Temp_f, nCells, Temp_c, "fluid", "charge", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "charge", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt

    # Build solution array: shape (3, nCells)
    x = (np.arange(nCells) + 0.5) * dx
    solArr = np.zeros((3, nCells))
    solArr[0, :] = x
    solArr[1, :] = Temp_f
    solArr[2, :] = Temp_s

    # Plot results
    PlotFigure("charge.dat", "height", "temperature", labels, 3, nCells, solArr)


def SteadyCycle(nCells, Temp_c, Temp_d, duration):
    # height, dt, ErrThd, Temp_ref,
    # EvolveTemp, PointImplicitMethod,
    # ThermalEnergy, MaxEnergyStored):
    """
    Python/Numpy translation of the Fortran SteadyCycle subroutine.

    Parameters
    ----------
    nCells : int
        Number of cells.
    Temp_c : float
        Charging (hot) inlet temperature.
    Temp_d : float
        Reference (dead) temperature.
    duration : array-like of length 4
        Durations of [charge, idle_1, discharge, idle_2] phases.
    height : float
        Domain height.
    dt : float
        Time step size.
    ErrThd : float
        Error threshold for convergence.
    Temp_ref : float
        Reference temperature for entropy/energy efficiency calc.
    EvolveTemp, PointImplicitMethod : callables
        Functions to evolve and couple temperatures.
    ThermalEnergy, MaxEnergyStored : callables
        Functions to compute stored energy and maximum capacity.
    """

    dx = height / nCells
    Temp_f = np.full(nCells, Temp_d)
    Temp_s = np.full(nCells, Temp_d)

    enEff_c = 0.0
    enEff_d = 0.0
    cycEff = 0.0
    preEff = 0.0
    nCycle = 0

    # Iterate until cycle efficiency converges
    while abs(cycEff - preEff) >= ErrThd * preEff:
        preEff = cycEff

        # --- Charging phase ---
        time = 0.0
        # Trapezoid rule: boundary term
        enEff_c += (Temp_f[-1] - Temp_f[0] -
                    Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))
        while time < duration[0]:
            Temp_f = EvolveTemp(Temp_f, nCells, Temp_c, "fluid", "charge", False)
            Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "charge", False)
            Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
            time += dt
            enEff_c += 2 * (Temp_f[-1] - Temp_f[0] -
                            Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))
        # Remove double-counted boundary term
        enEff_c -= (Temp_f[-1] - Temp_f[0] -
                    Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))

        # --- Idling phase ---
        time = 0.0
        while time < duration[1]:
            Temp_f = EvolveTemp(Temp_f, nCells, 0.0, "fluid", "idling", False)
            Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "idling", False)
            Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
            time += dt

        storEn = ThermalEnergy(nCells, Temp_f, Temp_s, Temp_d,
                               height=height, eps=eps,
                               rho_f=rho_f, C_f=C_f,
                               rho_s=rho_s, C_s=C_s,
                               diameter=diameter)

        # --- Discharging phase ---
        time = 0.0
        enEff_d += (Temp_f[-1] - Temp_f[0] -
                    Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))
        while time < duration[2]:
            Temp_f = EvolveTemp(Temp_f, nCells, Temp_d, "fluid", "dischg", False)
            Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "dischg", False)
            Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
            time += dt
            enEff_d += 2 * (Temp_f[-1] - Temp_f[0] -
                            Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))
        enEff_d -= (Temp_f[-1] - Temp_f[0] -
                    Temp_ref * np.log(Temp_f[-1] / Temp_f[0]))

        # --- Idling phase ---
        time = 0.0
        while time < duration[3]:
            Temp_f = EvolveTemp(Temp_f, nCells, 0.0, "fluid", "idling", False)
            Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "idling", False)
            Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
            time += dt

        if enEff_c == 0:
            raise ZeroDivisionError("Error: Division by zero in cycle efficiency")
        cycEff = enEff_d / enEff_c
        nCycle += 1

        if nCycle % 100 == 0:
            print("nCycle", nCycle, "cycEff", cycEff)

    print("Total nCycle", nCycle)

    # Capacity factor
    storEn = storEn - ThermalEnergy(nCells, Temp_f, Temp_s, Temp_d,
                                    height=height, eps=eps,
                                    rho_f=rho_f, C_f=C_f,
                                    rho_s=rho_s, C_s=C_s,
                                    diameter=diameter)
    maxEn = MaxEnergyStored(Temp_c, Temp_d,
                            eps=eps, rho_f=rho_f, C_f=C_f,
                            rho_s=rho_s, C_s=C_s,
                            diameter=diameter, height=height)
    capFact = storEn / maxEn

    # Run charging phase once more to get outflow temperature
    time = 0.0
    while time < duration[0]:
        Temp_f = EvolveTemp(Temp_f, nCells, Temp_c, "fluid", "charge", False)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", "charge", False)
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)
        time += dt

    print("Temperature increase at outflow", Temp_f[-1] - Temp_d)
    print("Cycle energy efficiency", cycEff)
    print("Capacity factor", capFact)

    return cycEff, capFact, Temp_f[-1] - Temp_d


# %% Measure
def ErrorNorms(nCells, arr_f, arr_i, Rel=False):
    """
    Python/Numpy translation of the Fortran ErrorNorms function.

    Parameters
    ----------
    nCells : int
        Number of cells.
    arr_f : np.ndarray
        Final/approximate solution array.
    arr_i : np.ndarray
        Initial or reference solution array.
    Rel : bool
        If True, compute relative error; if False, absolute error.

    Returns
    -------
    np.ndarray
        [errL1, errL2, errInf, errInfLoc]
        - errL1: mean absolute error
        - errL2: root mean square error
        - errInf: maximum error
        - errInfLoc: index (1-based, like Fortran) of maximum error
    """

    arr_f = np.asarray(arr_f)
    arr_i = np.asarray(arr_i)

    if Rel:
        if np.any(arr_i == 0):
            raise ZeroDivisionError("ErrorNorms: divided by 0 in relative error mode")
        errs = np.abs((arr_f - arr_i) / arr_i)
    else:
        errs = np.abs(arr_f - arr_i)

    errL1 = np.mean(errs)
    errL2 = np.sqrt(np.mean(errs**2))
    errInfLoc = int(np.argmax(errs)) + 1  # +1 to mimic Fortran's 1-based index
    errInf = errs[errInfLoc - 1]

    return np.array([errL1, errL2, errInf, float(errInfLoc)])


def ThermalEnergy(nCells, Temp_f, Temp_s, Temp_d,
                  height, eps, rho_f, C_f, rho_s, C_s, diameter):
    """
    Python/Numpy translation of the Fortran ThermalEnergy function.

    Parameters
    ----------
    nCells : int
        Number of cells.
    Temp_f, Temp_s : np.ndarray
        Fluid and solid temperature arrays.
    Temp_d : float
        Reference (dead) temperature.
    height : float
        Domain height.
    eps : float
        Porosity (fraction of fluid).
    rho_f, rho_s : float
        Densities of fluid and solid.
    C_f, C_s : float
        Heat capacities of fluid and solid.
    diameter : float
        Diameter of the domain (for cross-sectional area).

    Returns
    -------
    float
        Thermal energy.
    """

    dx = height / nCells

    # Integrals of temperature fields minus reference contribution
    sum_f = np.sum(Temp_f) * dx - Temp_d * height
    sum_s = np.sum(Temp_s) * dx - Temp_d * height

    # Energy contributions
    energy = (eps * rho_f * C_f * sum_f + (1.0 - eps) * rho_s * C_s * sum_s)

    # Multiply by cross-sectional area (π/4 * D^2)
    energy *= np.pi / 4.0 * diameter**2

    return energy

def MaxEnergyStored(Temp_c, Temp_d,
                    eps, rho_f, C_f, rho_s, C_s,
                    diameter, height):
    """
    Python/Numpy translation of the Fortran MaxEnergyStored function.

    Parameters
    ----------
    Temp_c : float
        Charging (hot) temperature.
    Temp_d : float
        Reference (dead) temperature.
    eps : float
        Porosity (fraction of fluid).
    rho_f, rho_s : float
        Densities of fluid and solid.
    C_f, C_s : float
        Heat capacities of fluid and solid.
    diameter : float
        Diameter of the storage domain.
    height : float
        Height of the storage domain.

    Returns
    -------
    float
        Maximum thermal energy stored.
    """

    # Effective volumetric heat capacity (weighted by porosity)
    cap_eff = eps * rho_f * C_f + (1.0 - eps) * rho_s * C_s

    # Cross-sectional area
    area = np.pi / 4.0 * diameter**2

    # Energy = capacity × volume × ΔT
    energy = cap_eff * area * height * (Temp_c - Temp_d)

    return energy


# %% Dynamics
def EvolveTemp(Temp, nCells, Temp_in, phase, charge, MMS):
    #    height, waveNum, dt, u_f, alpha_f, alpha_s, h_vf, h_vs):
    """
    Python/Numpy translation of the Fortran EvolveTemp subroutine.

    Parameters
    ----------
    Temp : np.ndarray
        Temperature array (modified in place).
    nCells : int
        Number of cells.
    Temp_in : float
        Inlet temperature.
    phase : str
        "fluid" or "solid".
    charge : str
        "charge", "dischg", or "idling".
    MMS : bool
        Manufactured solution flag.
    Other parameters are physical constants.
    """

    dx = height / nCells
    kn_f = 2 * np.pi * waveNum / height
    kn_s = 2 * kn_f

    if phase == "fluid":
        sigma = u_f * dt / dx
        d = alpha_f * dt / (dx * dx)
        k = kn_f
        h_c = h_vf * dt / dx
    elif phase == "solid":
        sigma = 0.0
        d = alpha_s * dt / (dx * dx)
        k = kn_s
        h_c = -h_vs * dt / dx
    else:
        raise ValueError("phase must be 'fluid' or 'solid'")

    allFlux = np.zeros(nCells)

    if MMS and charge == "charge":
        # MMS case with T = cos(kx)

        # Inlet boundary
        flux = -sigma * (-Temp[1]/2.0 + Temp[0]/2.0 + Temp_in)
        manSol = sigma
        allFlux[0] -= flux + manSol

        # Interior faces
        for i in range(nCells - 1):
            flux = -sigma * Temp[i] + d * (Temp[i+1] - Temp[i])
            manSol = (sigma * np.cos(k * dx * (i+1)) +
                      d * dx * k * np.sin(k * dx * (i+1)) +
                      h_c * (np.sin(kn_f * dx * (i+1)) / kn_f -
                             np.sin(kn_s * dx * (i+1)) / kn_s))
            allFlux[i] += flux + manSol
            allFlux[i+1] -= flux + manSol

        # Outlet boundary
        flux = -sigma * Temp[-1]
        manSol = sigma
        allFlux[-1] += flux + manSol

    elif charge == "charge":
        # Real simulation

        flux = -sigma * (-Temp[1]/2.0 + Temp[0]/2.0 + Temp_in)
        allFlux[0] -= flux

        for i in range(nCells - 1):
            flux = -sigma * Temp[i] + d * (Temp[i+1] - Temp[i])
            allFlux[i] += flux
            allFlux[i+1] -= flux

        flux = -sigma * Temp[-1]
        allFlux[-1] += flux

    elif charge == "dischg":
        # Discharge case (upwind reflection)

        flux = -sigma * (-Temp[-2]/2.0 + Temp[-1]/2.0 + Temp_in)
        allFlux[-1] -= flux

        for i in range(nCells - 1):
            flux = -sigma * Temp[-(i+1)] + d * (Temp[-(i+2)] - Temp[-(i+1)])
            allFlux[-(i+1)] += flux
            allFlux[-(i+2)] -= flux

        flux = -sigma * Temp[0]
        allFlux[0] += flux

    elif charge == "idling":
        # Idle phase: pure diffusion
        for i in range(nCells - 1):
            flux = d * (Temp[i+1] - Temp[i])
            allFlux[i] += flux
            allFlux[i+1] -= flux

    else:
        raise ValueError("Invalid charge state")

    # Update Temp
    Temp = Temp + allFlux
    return Temp


def PointImplicitMethod(Temp_f, Temp_s, nCells):#, h_vf, h_vs, dt):
    """
    Python/Numpy translation of the Fortran PointImplicitMethod subroutine.

    Parameters
    ----------
    Temp_f, Temp_s : np.ndarray
        Fluid and solid temperature arrays (modified in place).
    nCells : int
        Number of cells.
    h_vf, h_vs : float
        Coupling coefficients.
    dt : float
        Time step size.

    Returns
    -------
    Temp_f, Temp_s : np.ndarray
        Updated arrays.
    """

    det = 1.0 + (h_vf + h_vs) * dt

    # Coupling matrix
    matrix = np.zeros((2, 2))
    matrix[0, 0] = (1.0 + h_vs * dt) / det
    matrix[1, 0] = h_vf * dt / det
    matrix[0, 1] = h_vs * dt / det
    matrix[1, 1] = (1.0 + h_vf * dt) / det

    # Apply to each cell
    for i in range(nCells):
        var1 = Temp_f[i]
        var2 = Temp_s[i]
        Temp_f[i] = matrix[0, 0] * var1 + matrix[1, 0] * var2
        Temp_s[i] = matrix[0, 1] * var1 + matrix[1, 1] * var2

    return Temp_f, Temp_s


# %% Order_Verification
def SteadyState(Temp_f, Temp_s, nCells, Temp_in, charge, MMS, manSol_f,
                manSol_s):#, MaxTStep, dt, ErrThd):
    """
    Python/Numpy translation of the Fortran SteadyState subroutine.
    
    Parameters
    ----------
    Temp_f, Temp_s : np.ndarray
        Fluid and solid temperature arrays (modified in place).
    nCells : int
        Number of cells.
    Temp_in : float
        Inlet temperature for fluid.
    charge : str
        Charge string (length 6 in Fortran).
    MMS : bool
        Manufactured solution flag.
    manSol_f, manSol_s : np.ndarray
        Manufactured solution arrays for fluid and solid.
    MaxTStep : int
        Maximum number of time steps.
    dt : float
        Time step size.
    ErrThd : float
        Error threshold.
    """

    for tStep in range(1, MaxTStep + 1):
        # Record previous temperatures
        preT_f = Temp_f.copy()
        preT_s = Temp_s.copy()

        # Evolve both phases
        Temp_f = EvolveTemp(Temp_f, nCells, Temp_in, "fluid", charge, MMS)
        Temp_s = EvolveTemp(Temp_s, nCells, 0.0, "solid", charge, MMS)

        # Couple phases
        Temp_f, Temp_s = PointImplicitMethod(Temp_f, Temp_s, nCells)

        # Error norms for dT/dt
        stdyErr_f = ErrorNorms(nCells, Temp_f, preT_f, False)
        stdyErr_s = ErrorNorms(nCells, Temp_s, preT_s, False)

        # Discretization error vs manufactured solution
        discErr_f = ErrorNorms(nCells, Temp_f, manSol_f, True)
        discErr_s = ErrorNorms(nCells, Temp_s, manSol_s, True)

        # Progress output every 10% of MaxTStep
        if tStep % (MaxTStep // 10) == 0:
            print(f"For 2^{np.log(nCells)/np.log(2):.0f} cells,")
            print(f"After step {tStep}")
            print("Fluid phase:")
            print(f"dT/dt = {stdyErr_f[1]/dt}, stdyInfLoc = {int(stdyErr_f[3])}")
            print(f"discL2 = {discErr_f[1]}, dicsInfLoc = {int(discErr_f[3])}")
            print("Solid phase:")
            print(f"dT/dt = {stdyErr_s[1]/dt}, stdyInfLoc = {int(stdyErr_s[3])}")
            print(f"discL2 = {discErr_s[1]}, dicsInfLoc = {int(discErr_s[3])}")
            print()

        # Convergence check
        if (stdyErr_f[1]/dt < ErrThd * discErr_f[1] and
            stdyErr_s[1]/dt < ErrThd * discErr_s[1]):
            print(f"For 2^{np.log(nCells)/np.log(2):.0f} cells,")
            print(f"Approximate solution converges after step {tStep}")
            print("Fluid phase:")
            print(f"dT/dt = {stdyErr_f[1]/dt}, stdyInfLoc = {int(stdyErr_f[3])}")
            print(f"discL2 = {discErr_f[1]}, dicsInfLoc = {int(discErr_f[3])}")
            print("Solid phase:")
            print(f"dT/dt = {stdyErr_s[1]/dt}, stdyInfLoc = {int(stdyErr_s[3])}")
            print(f"discL2 = {discErr_s[1]}, dicsInfLoc = {int(discErr_s[3])}")
            print()
            break

        elif tStep == MaxTStep:
            print(f"For 2^{np.log(nCells)/np.log(2):.0f} cells,")
            print("Approximate solution CANNOT converge!")
            raise RuntimeError("SteadyState did not converge")

    return Temp_f, Temp_s


def GridRefinement(waveNum, height, pt_i, pt_f,
                   SteadyState, ErrorNorms, VisualTemp, PlotFigure):
    """
    Python/Numpy translation of the Fortran GridRefinement subroutine.

    Parameters
    ----------
    waveNum : float
        Wavenumber used in manufactured solution.
    height : float
        Domain height.
    pt_i, pt_f : int
        Range of refinement levels (powers of 2).
    SteadyState : callable
        Function to evolve Temp_f, Temp_s to steady state.
    ErrorNorms : callable
        Function to compute error norms.
    VisualTemp : callable
        Function to visualize solutions.
    PlotFigure : callable
        Function to plot results.
    """

    k = 2 * np.pi * waveNum / height
    pt = pt_f - pt_i + 1  # number of refinement levels

    # Allocate error and location arrays
    errArr_f = np.zeros((4, pt))
    errArr_s = np.zeros((4, pt))
    locArr_f = np.zeros((2, pt))
    locArr_s = np.zeros((2, pt))

    for i in range(pt):
        nCells = 2 ** (pt_i + i)
        dx = height / nCells

        # Manufactured solutions
        j = np.arange(1, nCells + 1)
        manSol_f = 2.0 + np.cos(k * dx * (j - 0.5))
        manSol_s = 2.0 + np.cos(2.0 * k * dx * (j - 0.5))

        # Initial conditions
        Temp_f = manSol_f.copy()
        Temp_s = manSol_s.copy()

        # Evolve to steady state
        Temp_f, Temp_s = SteadyState(Temp_f, Temp_s, nCells,
                                     Temp_in=3.0,
                                     charge="charge",
                                     MMS=True,
                                     manSol_f=manSol_f,
                                     manSol_s=manSol_s)

        # Discretization error norms
        discErr_f = ErrorNorms(nCells, Temp_f, manSol_f, True)
        discErr_s = ErrorNorms(nCells, Temp_s, manSol_s, True)

        # Visualization at a chosen resolution
        if nCells == 2 ** 10:
            VisualTemp(nCells, Temp_f, Temp_s, True, manSol_f, manSol_s)

        # Store error norms (log10)
        errArr_f[:, i] = [np.log10(dx),
                          np.log10(discErr_f[0]),
                          np.log10(discErr_f[1]),
                          np.log10(discErr_f[2])]
        locArr_f[:, i] = [np.log10(dx),
                          (discErr_f[3] - 0.5) * dx]

        errArr_s[:, i] = [np.log10(dx),
                          np.log10(discErr_s[0]),
                          np.log10(discErr_s[1]),
                          np.log10(discErr_s[2])]
        locArr_s[:, i] = [np.log10(dx),
                          (discErr_s[3] - 0.5) * dx]

    # Labels
    label2 = ["dx", "L1", "L2", "Inf"]
    label3 = ["dx", "Inf"]

    # Plot results
    PlotFigure("discErr_f.dat", "log10(dx)", "log10(error)",
               label2, 4, pt, errArr_f)
    PlotFigure("discLoc_f.dat", "log10(dx)", "height",
               label3, 2, pt, locArr_f)

    PlotFigure("discErr_s.dat", "log10(dx)", "log10(error)",
               label2, 4, pt, errArr_s)
    PlotFigure("discLoc_s.dat", "log10(dx)", "height",
               label3, 2, pt, locArr_s)


# %% MAIN PARAMETERS (1)
Temp_ref = 288.15
ErrThd   = 1.0e-05
nCells   = 1024
MaxTStep = 10_000_000
waveNum  = 1
pt_i     = 3
pt_f     = 6
dt       = 10.0
volume   = 300
diameter = 4
rho_f    = 1835.6
rho_s    = 2600
C_f      = 1511.8
C_s      = 900
k_f      = 0.52
k_s      = 2.00
eps      = 0.4
d_s      = 0.03
mu_f     = 2.63
dm       = 10.0

# %% MAIN PARAMETERS (2)
height = volume*4/(np.pi*diameter**2)
u_f = dm/(rho_f*eps*np.pi*diameter**2/4)

alpha_f = k_f/(eps*rho_f*C_f)
alpha_s = k_s/((1.0-eps)*rho_s*C_s)

Pr = mu_f*C_f/k_f
Re = eps*rho_f*u_f*d_s/mu_f
Nu = 0.255/eps*Pr**(1./3)*Re**(2./3)

h_fs = Nu*k_f/d_s
h = 1/(1/h_fs + d_s/(10*k_s))

h_v = 6*(1-eps)*h/d_s
h_vf = h_v/(eps*rho_f*C_f)
h_vs = h_v/((1.-eps)*rho_s*C_s)


# %%
study = "OVS"
study = "exSol"
# study = "realSim"

# %%
if study == "OVS":
    # Order verification study with source term
    GridRefinement(waveNum, height, pt_i, pt_f, SteadyState,
                   ErrorNorms, VisualTemp, PlotFigure)

# %%
if study == "exSol":
    # Visualize thermocline motions of one cycle
    VisualMotion(2**10, 873.0, 293.0, [21600.0, 21600., 21600., 21600],
                 height, dt, EvolveTemp, PointImplicitMethod, PlotFigure)

    # Compare with exact solutions
    CompareExSol(nCells, 873., 293., [5000., 0., 0., 0.])

# %%
# if study == "realSim":
SteadyCycle(nCells, 873., 293., [21600., 21600., 21600., 21600.])
# %%
