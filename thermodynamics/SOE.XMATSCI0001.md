# Course notes

Notes taken while following this [course](https://learning.edx.org/course/course-v1:StanfordOnline+SOE.XMATSCI0001+1T2020/home) by [Alberto Salleo](https://profiles.stanford.edu/alberto-salleo).

- Preamble
	- [Thermodynamics and Phase Equilibria: Introduction](https://www.youtube.com/watch?v=bEUiUfunnvI)
	- [Historical overview](https://www.youtube.com/watch?v=GKO3MXExI2s)
	- [Definitions of Fundamental Concepts](https://www.youtube.com/watch?v=INwjv9HDCt0)

- Chapter 1
	- [Foundations](https://www.youtube.com/watch?v=s4UAlDe9-l8)
	- [Heat and Work](https://www.youtube.com/watch?v=4on5epShTrU)
	- [James Joule](https://www.youtube.com/watch?v=id8kgbaYpKM)
	- [Definition and Sign Convention for Work](https://www.youtube.com/watch?v=7nWm_KXV8Mo)
	- [First Law of Thermodynamics](https://www.youtube.com/watch?v=XTx-su6s_sA)
	- [Caloric Equation of State](https://www.youtube.com/watch?v=K90C6w-FP8I)
	- [Generalized Form of the First Law](https://www.youtube.com/watch?v=7h2tcB9fxN0)
	- [Internal Energy of an Ideal Gas](https://www.youtube.com/watch?v=vVySRn5vpHY)
	- [Need for Entropy](https://www.youtube.com/watch?v=tz0mm8zwj9k)
	- [Inaccessibility and Empirical Entropy](https://www.youtube.com/watch?v=AN2ndlPuOiE)
	- [Metrical Entropy](https://www.youtube.com/watch?v=2Kd0eJFO3U4)
	- [Adiabatic Processes](https://www.youtube.com/watch?v=G27IGHhMhQE)
	- [Carnot Inequality](https://www.youtube.com/watch?v=Tso3_y8gKIM)
	- [Isothermal Processes](https://www.youtube.com/watch?v=rN9RDoCThIk)
	- [Sadi Carnot](https://www.youtube.com/watch?v=CJM-hHHG28Q)
	- [Second Law of Thermodynamics](https://www.youtube.com/watch?v=AQ8SMZdoRFY)
	- [Equilibrium](https://www.youtube.com/watch?v=rVK77TYw1hE)
	- [3rd Law Measurability of Entropy](https://www.youtube.com/watch?v=tNekt9tBbwY)
	
## Foundations

Thermodynamics is not good at predicting what will happen - that is generally governed by kinetics - but can tell you what cannot happen. All observable processes have to be allowed by thermodynamics. Our goal in what follows is to understand which properties of materials must be measured so that predictions can be made regarding their phase transformations and how to assemble the equations to perform such predictions.

Historically, thermodynamics is a science born from practical engineering needs. In fact, it arose as England needed to develop the steam engine to be able to mine coal. At the same time, in France, its political rival at the time, Sadi Carnot developed further the science introducing the concept of entropy and maximum efficiency of an engine. Later on, in Austria, Boltzmann highly theoretical work linked entropy to atomistic behavior, what became fundamental in many fields. Currently the concept of entropy is used in cosmology, information science, linguistics, and so on, revealing the importance of thermodynamics as a general framework for describing the macroscopic world.

A large part of thermodynamics relies on the classification of systems, their boundaries, and the constitutive laws closing the description of the physics governing the system. That said, thermodynamics is an intrinsically semi-empirical science. The most basic type of system is the isolated system, for which no form of energy (heat, work, etc.) or mass exchanges is allowed. On the other hand, a system can be adiabatic, so that heat exchanges are not possible but work can be exerted by/upon the system. Adiabatic systems cannot exchange matter with their surroundings.
### System classification

#system/isolated #system/adiabatic

To go further in the classification, it is clear by now that classification of system boundaries is an important matter. Regarding heat transfer, a system can be classified as diathermal, allowing heat exchanges with the environment, or adiabatic, as described above.

### Boundary classification

#boundary/diathermal #boundary/adiabatic

In terms of mechanical work, a moving boundary allows work to be performed by the system upon its surroundings or vice-versa. On the other hand, a rigid boundary disallows mechanical work interactions.

#boundary/moving #boundary/rigid

Finally, regarding matter transport the boundaries can be permeable or impermeable; as discussed before, a permeable boundary cannot be classified as adiabatic, as matter transports energy.

#boundary/permeable #boundary/impermeable

### Constitutive laws

In order to provide the closure of a system's description, in thermodynamics we use *constitutive laws*. These are provided by constitutive coordinates (physical quantities) that uniquely define the state of a system. The relationships between constitutive coordinates make up the constitutive equations of a system.

#constitutive/coordinates #constitutive/equations

A class of materials is a group that share the same constitutive coordinates. For instance, in thermodynamics a fluid is described by a pressure $p$, temperature $T$, number of moles $n$ and volume $V$; an example of constitutive law linking these measurables is the *ideal gas law*. A *solid* material being described by this same set of coordinates can also be classified as a fluid, what can be counterintuitive. In fact, real world solids can also present anisotropic stress dependences, leading to their own class of materials, but that will not be treated in this course.

#material/class/fluid #mateiral/class/solid

> [!IMPORTANT]
> It must be emphasized that in most practical applications an additional set of constitutive coordinates need to be added to a fluid description, the mass fractions $Y_k$ of its various components.

To wrap up this section, we can also provide a type to a material of a given class. All materials of the same class described by the same specific constitutive equation are said to be of the same type. In a complex model, different materials of the same class composing a system may eventually be described as being of different types (models), for instance, as an *ideal gas* or obeying *Van der Waals* equation.

#material/type 

### Heat and work

The expression of the laws of thermodynamics is built upon relationships between heat and work and how they change the internal state of the system. Although all of them are expressed in units of energy, they are fundamentally different. Work is provided by *organized* motion of particles with net displacement, while heat is related to *random fluctuations* with zero displacement. Everything else is accounted for the *internal energy*, which is linked to the microscopic scales (essentially atomic motion) not described in thermodynamics. Joule demonstrated the equivalence between heat and work, disproving the belief that, at his time, heat was intrinsically contained in the material being submitted to work.

#energy/heat #energy/work #energy/internal

It is important to keep a consistent sign convention for work and heat in thermodynamics; here we adopt a system-centric approach where work *performed on* the system, *e.g.* by reducing its volume, is positive, while work *performed by* the system - consequently reducing its internal energy - is negative. By the definition of pressure $p$, for a piston, we have

$$
W = \int_{1}^{2}p_{ext}Adx = -p_{ext}\Delta{}V
$$

where the external pressure $p_{ext}$ is used because it is the value that performs work or upon which work is performed against, until equilibrium is reached. The sign convention displays the above definitions, meaning that a reduction of volume $\Delta{}V<0$ would imply work performed on the system. Following the same logic, heat $Q$ provided to the system has a positive sign, while heat transferred from the system to its surroundings has a negative sign.

In the previous expression we have work defined as the product of a field $p$ multiplied by an *extensive* quantity $V$. Fields is what in thermodynamics we call *intensive* variables, those defined as a distribution in space; their *extensive* counterpart hold the property of being additive and can only be defined for the system as a whole. There are always pairs of *conjugate* intensive and extensive variables as we will show later. Work will always be represented by an intensive quantity multiplied by a change in an extensive quantity.

#quantity/extensive #quantity/intensive

### First law of thermodynamics

#variable/state #variable/path


#process/reversible #process/irreversible

#process/isothermal

### Entropy and second law

#entropy/empirical #entropy/metrical

### Equations summary

$$
\begin{align*}
dU &= \delta{}Q + \delta{}W \qquad \delta{}W=-p_{ext}dV
\\[12pt]
dU &= TdS - pdV
\end{align*}
$$

$$
dS = \frac{\delta{}Q_{rev}}{T}
\qquad
dS \ge \frac{\delta{}Q}{T}
$$

$$
S = k\log(w)
$$

### Knowledge check

- A permeable membrane cannot be adiabatic: *true*.

- The chemical identity of the atoms is a constitutive coordinate of an ideal gas: *false*.

- The internal energy of all materials is 0J at T=0K: *false*. Internal energy is not an absolute number.

- If a system completes a cycle, $\Delta{}U_{sys}=0$ and $\Delta{}U_{surroundings}=0$ no matter what: *true*. Internal energy $U$ is a state function.

- The internal energy of a system is always conserved: *false*. The energy of the Universe is conserved, but individually, the energy of the system or surrounding are not always.

- What is the force pertaining to expansion work? $-p$.

- In what scenario does the temperature of an ideal gas decrease upon adiabatic expansion?
	- [ ] Work is performed on the system
	- [x] Work is performed by the system; Work performed *by* the system is negative under the defined sign convention. Since $\delta{}Q = 0$ for adiabatic systems, the first law simplifies to $dU = \delta{}W$. A decrease in temperature corresponds to a decrease in internal energy of the system, so $\delta{}W$ must be negative as well.
	- [ ] Heat is provided to the system
	- [ ] Heat is removed from the system

- Any spontaneous adiabatic transformation of a material increases its entropy: *true*.

- In going from a state A to a state B, an adiabatic system can either take a reversible path or an irreversible path: *false*. Entropy $S$ is a state function. Along the irreversible path $\Delta{}S>0$ while along the other $\Delta{}S=0$, this is a contradiction.

- Why can't adiabatic lines ever cross?
	- [ ] Higher energy states would be accessible
	- [ ] Lower energy states would be accessible
	- [ ] Higher entropy states would be accessible
	- [x] Lower entropy states would be accessible

- It is possible to have an adiabatic cycle with an irreversible leg: *false*.

- In going from a state A to a state B, an isothermal system can either take a reversible path or an irreversible path: *true*.

- What is the entropy change of a system undergoing an irreversible isothermal cycle? *0*. Even though the cycle is irreversible, the system is able to return to its original state.

- What about the surroundings? *>0*. The surroundings will gain more heat after the cycle completes. Therefore, $S_{surr}>0$.

- The entropy of the Universe always increases when a system spontaneously evolves towards equilibrium: *true*.

- If a system completes a cycle, $\Delta{}S_{sys}=0$ and $\Delta{}S_{surr}=0$ no matter what: *false*. If the cycle contains an irreversible leg $\Delta{}S_{surr}>0$.

## Tools for materials equilibria

## Unary systems

## Solution thermodynamics

### Solution thermodynamics tools

### Solution models

## Phase diagrams

### Constructing phase diagrams

### Types of phase diagrams

## Equilibrium thermodynamics

### Chemical equilibria between gaseous species

### Solid-gas reactions
