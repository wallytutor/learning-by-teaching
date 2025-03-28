# kinetics.py
# by Walter Dal'Maz Silva
# on 19th February 2017

import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# -------------------------------------------------------------------
# Plot style
# -------------------------------------------------------------------

xutils = "/home/dalmazsi1/root/rep/wapps/xutils-git"
dirpath = os.path.join(xutils, "xpython/xchemistry/xcantera/aux")
plt.style.use(os.path.join(dirpath,'xcantera'))

# -------------------------------------------------------------------
# Global variables
# -------------------------------------------------------------------

R = 8.314472
Patm = 1.0e+05
teff = np.linspace(0.0, 2.0, 100)

# -------------------------------------------------------------------
# Effective time conversion approach
# -------------------------------------------------------------------

def F(t, P, T, X, k, n):
    """ Returns the residual fraction of species.

        @param t  residence time, s
        @param P  operating pressure, Pa
        @param T  operating temperature, K
        @param X  inicial mole fraction, none
        @param k  rate constant function, m**3*mole*-1*s*-1
        @param n  global reaction order, none

        @return resial fraction of input X.
    """
    C = P * X / (R * T)
    F = (1.0 + k(T) * (n - 1.0) * t / C ** (1.0 - n))
    return F ** (1.0 / (1.0 - n))

# -------------------------------------------------------------------
# Operating conditions
# -------------------------------------------------------------------

T = 1173.0
X = 0.36

# -------------------------------------------------------------------
# Norinaga validation
# -------------------------------------------------------------------

#k = lambda T : 1.50
#n = 2.70

#Test02 = F(teff, 0.02 * Patm, T, 1.0, k, n)
#Test04 = F(teff, 0.04 * Patm, T, 1.0, k, n)
#Test08 = F(teff, 0.08 * Patm, T, 1.0, k, n)
#Test15 = F(teff, 0.15 * Patm, T, 1.0, k, n)

#plt.clf()
#plt.figure(figsize=(6,3))
#plt.xlabel('Temps de séjour (\\si{\\second})')
#plt.ylabel('\\ch{C2H2} Résiduel')

#ax = plt.subplot(1, 1, 1)
#y_format = lambda y, p : format(y, '.2f').replace('.', ',')
#x_format = lambda x, p : format(x, '.1f').replace('.', ',')
#ax.get_yaxis().set_major_formatter(ticker.FuncFormatter(y_format))
#ax.get_xaxis().set_major_formatter(ticker.FuncFormatter(x_format))
#plt.subplot(1, 1, 1)

#plt.plot(teff, Test02, '-', c='k', label='x')
#plt.plot(teff, Test04, '-', c='g', label='x')
#plt.plot(teff, Test08, '-', c='b', label='x')
#plt.plot(teff, Test15, '-', c='r', label='x')

#plt.legend(loc=3)
#plt.savefig('conversion-Norinaga2005.png', dpi=400)

# -------------------------------------------------------------------
# Norinaga LP
# -------------------------------------------------------------------

k = lambda T : 1.50
n = 2.70

Fres0 = F(teff, 0.05 * Patm, T, X, k, n)
Fres1 = F(teff, 0.10 * Patm, T, X, k, n)

# -------------------------------------------------------------------
# Mine LP
# -------------------------------------------------------------------

k = lambda T : 3.86e+04 * np.exp(-100.7e+03 / (R * T))
n = 2.163

Fres2 = F(teff, 0.05 * Patm, T, X, k, n)
Fres3 = F(teff, 0.10 * Patm, T, X, k, n)

# -------------------------------------------------------------------
# Plot results LP
# -------------------------------------------------------------------

plt.clf()
plt.figure(figsize=(6,3))
plt.xlabel('Temps de séjour (\\si{\\second})')
plt.ylabel('\\ch{C2H2} Résiduel')

ax = plt.subplot(1, 1, 1)
y_format = lambda y, p : format(y, '.2f').replace('.', ',')
x_format = lambda x, p : format(x, '.1f').replace('.', ',')
ax.get_yaxis().set_major_formatter(ticker.FuncFormatter(y_format))
ax.get_xaxis().set_major_formatter(ticker.FuncFormatter(x_format))
plt.subplot(1, 1, 1)

h050 = '\\SI{50}{\\hecto\\pascal}'
h100 = '\\SI{100}{\\hecto\\pascal}'
plt.plot(teff, Fres0, '-.', c='b', label='Norinaga -- ' + h050)
plt.plot(teff, Fres1, '-.', c='r', label='Norinaga -- ' + h100)
plt.plot(teff, Fres2, '-', c='b', label='Ce travail -- ' + h050)
plt.plot(teff, Fres3, '-', c='r', label='Ce travail -- ' + h100)

plt.legend(loc=3)
plt.savefig('conversion-low-pressure.png', dpi=400)

# -------------------------------------------------------------------
# Mine: Temperature effect
# -------------------------------------------------------------------

plt.clf()
plt.figure(figsize=(6,3))
plt.xlabel('Temps de séjour (\\si{\\second})')
plt.ylabel('\\ch{C2H2} Résiduel')

ax = plt.subplot(1, 1, 1)
y_format = lambda y, p : format(y, '.2f').replace('.', ',')
x_format = lambda x, p : format(x, '.1f').replace('.', ',')
ax.get_yaxis().set_major_formatter(ticker.FuncFormatter(y_format))
ax.get_xaxis().set_major_formatter(ticker.FuncFormatter(x_format))
plt.subplot(1, 1, 1)

for Temp in np.arange(873.0, 1273.1, 100.0):
    Fresi = F(teff, 0.05 * Patm, Temp, X, k, n)
    label = '\\SI{' + str(int(Temp)) + '}{\\kelvin}'
    plt.plot(teff, Fresi, '-', label=label)

plt.legend(loc=3)
plt.savefig('conversion-temperature-effect.png', dpi=400)

# -------------------------------------------------------------------
# EOF
# -------------------------------------------------------------------
