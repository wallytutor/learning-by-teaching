# Course notes

Notes taken while following this [course](https://learning.edx.org/course/course-v1:StanfordOnline+SOE.XMATSCI0001+1T2020/home) by [Alberto Salleo](https://profiles.stanford.edu/alberto-salleo).

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

To wrap up this section, we can also provide a type to a material of a given class. All materials of the same class described by the same specific constitutive equation are said to be of the same type. In a complex model, different materials of the same class composing a system may eventually be described as being of different types (models).

#material/type 

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
