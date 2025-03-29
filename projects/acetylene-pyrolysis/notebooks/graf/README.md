# Graf's global kinetics


In this study we will perform the integration of a simplified chemical mechanism of acetylene pyrolysis as provided in this [thesis](https://publikationen.bibliothek.kit.edu/1000007244/97488) by [@Graf2007]. This mechanism is composed by 7 chemical species and the reaction rate equations are given in the table below. Although such simplified mechanism does not hold the thermodynamics of the system (because equations are not expressed in mass action kinetics formalism), it proves useful for CFD computation of chemically reacting flows since it largely reduces the number of equations to solve - a detailed acetylene pyrolysis mechanism such as [@Norinaga2009] has more than 200 chemical species, requiring integration of each of them in the simulated system. Such a detailed simulation would require the solution of mass, momentum, energy, and species simulations. Just a conventional CFD simulation can already prove difficult in computational terms, adding up species makes the problem exponentially more complex. The temperature dependent rate coefficient in these equations is given by $k(t)=A\exp\left(-\frac{E_a}{RT}\right)$, where the units of $A$ are such that the rate expression is given in moles per second, and $Ea$ is provided in $kJ$.


<table>
  <tr>
    <th style="width: 200px;">Reaction</th>
    <th style="width: 100px;">$A$</th>
    <th style="width: 100px;">$E_a$</th>
    <th style="width: 300px;">Rate</th>
  </tr>
  <tr>
    <td>$C_2H_2 + H_2 \rightarrow C_2H_4$</td>
    <td style="text-align: center;">4.4e+03</td>
    <td style="text-align: center;">1.0300e+05</td>
    <td>$r_{1}=k_{1}(T)[C_2H_2][H_2]^{0.36}$</td>
  </tr>
  <tr>
    <td>$C_2H_4 \rightarrow C_2H_2 + H_2$</td>
    <td style="text-align: center;">3.8e+07</td>
    <td style="text-align: center;">2.0000e+05</td>
    <td>$r_{2}=k_{2}(T)[C_2H_4]^{0.50}$</td>
  </tr>
  <tr>
    <td>$C_2H_2 + 3 H_2 \rightarrow 2 CH_4$</td>
    <td style="text-align: center;">1.4e+05</td>
    <td style="text-align: center;">1.5000e+05</td>
    <td>$r_{3}=k_{3}(T)[C_2H_2]^{0.35}[H_2]^{0.22}$</td>
  </tr>
  <tr>
    <td>$CH_4 + CH_4 \rightarrow C_2H_2 + 3 H_2$</td>
    <td style="text-align: center;">8.6e+06</td>
    <td style="text-align: center;">1.9500e+05</td>
    <td>$r_{4}=k_{4}(T)[CH_4]^{0.21}$</td>
  </tr>
  <tr>
    <td>$C_2H_2 + C_2H_2 \rightarrow C_4H_4$</td>
    <td style="text-align: center;">1.2e+05</td>
    <td style="text-align: center;">1.2070e+05</td>
    <td>$r_{6}=k_{6}(T)[C_2H_2]^{1.60}$</td>
  </tr>
  <tr>
    <td>$C_4H_4 \rightarrow C_2H_2 + C_2H_2$</td>
    <td style="text-align: center;">1.0e+15</td>
    <td style="text-align: center;">3.3520e+05</td>
    <td>$r_{7}=k_{7}(T)[C_4H_4]^{0.75}$</td>
  </tr>
  <tr>
    <td>$C_4H_4 + C_2H_2 \rightarrow C_6H_6$</td>
    <td style="text-align: center;">1.8e+03</td>
    <td style="text-align: center;">6.4500e+04</td>
    <td>$r_{8}=k_{8}(T)[C_2H_2]^{1.30}[C_4H_4]^{0.60}$</td>
  </tr>
  <tr>
    <td>$C_2H_2 \rightarrow 2 C(s) + H_2$</td>
    <td style="text-align: center;">5.5e+06</td>
    <td style="text-align: center;">1.6500e+05</td>
    <td>$r_{5}=k_{5}(T)\dfrac{[C_2H_2]^{1.90}}{1+18[H_2]}$</td>
  </tr>
  <tr>
    <td>$C_6H_6 \rightarrow 6 C(s) + 3 H_2$</td>
    <td style="text-align: center;">1.0e+03</td>
    <td style="text-align: center;">7.5000e+04</td>
    <td>$r_{9}=k_{9}(T)\dfrac{[C_6H_6]^{0.75}}{1+22[H_2]}$</td>
  </tr>
</table>


Generally, when dealing with chemical species, one writes the equations in terms of mass fractions. This is useful (and in many other applications) to easily evaluate mass balance. Rate equations are provided above are computed with concentrations, so if integrating mass fraction rates one must perform the conversion inside the rate expression, as provided below. The rate of generation/consumption of each species is given by the weighted sum of the rates of each equation where it appears multiplied by its stoichiometric coefficient in this reaction. For providing a general formulation, this is generally done with a matrix of stoichiometric coefficients often called $\nu$ (the Greek letter *nu*), where negative signs represent reacting species that are consumed and positive signs the generated products. Function `graf_kinetics` implements the species rates for this system as described above. Notice that for the porter gas $N_2$ that does not participate in reactions, we compute its rate as the balance of the other species, ensuring mass conservation in the system. You are invited to remove this balance and study the effect of integrating without it for different numerical tolerances: mass conservation, *i.e.* $\sum{}Y=1$, may diverge from unit depending on integration conditions.


## Cantera implementation

- [Chemically activated reactions](https://cantera.org/stable/reference/kinetics/rate-constants.html#chemically-activated-reactions)
- [Arbitrary reaction orders](https://cantera.org/stable/reference/kinetics/reaction-rates.html#reaction-orders)

```python
import cantera as ct
import numpy as np
import matplotlib.pyplot as plt
```

```python
class GrafSimulation:
    """ Simulate single reactor with Graf's mechanism. """
    def __init__(self, T, P, f, verbose=True):
        gas = ct.Solution("graf.yaml")
        gas.TPX = T, P, self._acetylene_mixture(f)
        
        reactor = ct.IdealGasConstPressureReactor(gas)
        reactor.energy_enabled = False
        
        simulation = ct.ReactorNet([reactor])
        simulation.verbose = verbose
    
        states = ct.SolutionArray(gas, extra=["t"])
        
        self._reactor = reactor
        self._simulation = simulation
        self._states = states

        self._feed_state()

    def _acetylene_mixture(self, f):
        """ Simulate single reactor with Graf's mechanism. """
        X = {"C2H2": 0.98 * f, "CH4": 0.002 * f}
        X["N2"] = 1.0 - sum(X.values())
        return X

    def _feed_state(self):
        """ Feed solution state to solution array. """
        state = self._reactor.thermo.state
        self._states.append(state, t=self._simulation.time)

    def run(self, tout, nsteps, ttol=1.0e-07):
        """ Simulate system until `tout` seconds in `nsteps` steps. """
        times = np.linspace(0, tout, nsteps)

        for tend in times[1:]:
            if self._simulation.time > tend:
                raise RuntimeError("Simulation time greater than exit time...")
                
            self._simulation.advance(tend)
            self._feed_state()
                
            if abs(tend - self._simulation.time) > ttol:
                raise RuntimeError("Unable to reach exit time during advance...")

        return self._states
```

```python
def plot_simulation(states):
    """ Displays model solution over time. """
    # Same indexing as Octave
    t = states.t
    y1 = states.C2H2
    y2 = states.H2
    y3 = states.C2H4
    y4 = states.CH4
    y5 = states.C4H4
    y6 = states.C6H6
    y7 = states.C

    plt.close("all")
    plt.ioff()

    fig, ax = plt.subplots(2, 2, figsize=(10, 8))
    ax = np.ravel(ax)
    
    def set_subplot(ax, ymin=0.0):
        ax.grid(linestyle=":")
        ax.set_xlabel("Time (s)")
        ax.set_ylabel("Mass fraction")
        ax.legend(loc="best")
        ax.set_xlim(0, t[-1])
        ax.set_ylim(ymin, None)
    
    ax[0].plot(t, y1, c="b", label="$C_2H_2$")
    ax[1].plot(t, y2, c="b", label="$H_2$")
    ax[1].plot(t, y7, c="r", label="$C_s$")
    ax[2].plot(t, y3, c="b", label="$C_2H_4$")
    ax[2].plot(t, y4, c="r", label="$CH_4$")
    ax[3].plot(t, y5, c="b", label="$C_4H_4$")
    ax[3].plot(t, y6, c="r", label="$C_6H_6$")
    
    set_subplot(ax[0], ymin=0.24)
    set_subplot(ax[1])
    set_subplot(ax[2])
    set_subplot(ax[3])
    
    fig.tight_layout()
    return fig, ax
```

```python
tout = 1.4
nsteps = 100

T = 1173.0
P = 5000.0
f = 0.36

simulation = GrafSimulation(T, P, f, verbose=False)
states = simulation.run(tout, nsteps)

fig, ax = plot_simulation(states)
fig.savefig("graf_plot_cantera.png", dpi=300)
```

![Reference scenario](graf_plot_cantera.png)


## Octave implementation

To run the integrator from an Octave terminal active at this level, call/modify `graf_main`.

![Reference scenario](graf_plot_octave.png)
