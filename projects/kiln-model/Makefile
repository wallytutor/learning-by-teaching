#######################################################################
# CONFIGURATION
#######################################################################

FC           = /usr/bin/gfortran
FCFLAGS      = -O2 -Wall -Jbin -fdefault-real-8

SRC_DIR      = src/fortran
BIN_DIR      = bin

CORE_DIR     = $(SRC_DIR)/core
MODS_DIR     = $(SRC_DIR)/models

MODULES      = \
	bin/coefficients.o    \
	bin/kinetics.o        \
	bin/kramers.o         \
	bin/plugflow.o        \
	bin/thermo.o          \
	bin/methane_air_1step.o

#######################################################################
# ALL
#######################################################################

all: $(BIN_DIR) bin/kiln.a
	$(FC) $(FCFLAGS) $(SRC_DIR)/application.f90 bin/kiln.a -o bin/application.out
	$(FC) $(FCFLAGS) $(SRC_DIR)/testing.f90     bin/kiln.a -o bin/testing.out

#######################################################################
# WORKFLOW
#######################################################################

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

venv:
	python3 -m venv venv
	. venv/bin/activate && python3 -m pip install --upgrade pip
	. venv/bin/activate && pip install -r docs/requirements.txt

doc: venv
	. venv/bin/activate && ford $(PWD)/docs/src/index.md -r 0.0.1

test: bin/testing.out
	@ ./bin/testing.out

bin/kiln.a: $(MODULES)
	ar rcs bin/kiln.a bin/*.o

#######################################################################
# CORE MODULES
#######################################################################

bin/coefficients.o: $(CORE_DIR)/coefficients.f90
	$(FC) $(FCFLAGS) -c $(CORE_DIR)/coefficients.f90 -o bin/coefficients.o

bin/kinetics.o: $(CORE_DIR)/kinetics.f90 bin/thermo.o
	$(FC) $(FCFLAGS) -c $(CORE_DIR)/kinetics.f90 -o bin/kinetics.o

bin/kramers.o: $(CORE_DIR)/kramers.f90
	$(FC) $(FCFLAGS) -c $(CORE_DIR)/kramers.f90 -o bin/kramers.o

bin/plugflow.o: $(CORE_DIR)/plugflow.f90
	$(FC) $(FCFLAGS) -c $(CORE_DIR)/plugflow.f90 -o bin/plugflow.o

bin/thermo.o: $(CORE_DIR)/thermo.f90
	$(FC) $(FCFLAGS) -c $(CORE_DIR)/thermo.f90 -o bin/thermo.o

bin/methane_air_1step.o: $(MODS_DIR)/methane_air_1step.f90 bin/thermo.o
	$(FC) $(FCFLAGS) -c $(MODS_DIR)/methane_air_1step.f90 -o bin/methane_air_1step.o

#######################################################################
# CLEAN
#######################################################################

clean:
	rm -rf $(BIN_DIR) $(SRC_DIR)/**/*.mod

dist-clean: clean
	rm -rf docs/build/ venv/

#######################################################################
# EOF
#######################################################################