#######################################################################
# CONFIGURATION
#######################################################################

FC           = /usr/bin/gfortran
FCFLAGS      = -O2 -Wall -Jbin -fdefault-real-8

SRC_DIR      = src
BIN_DIR      = bin

MODULES      = \
	bin/coefficients.o \
	bin/kinetics.o     \
	bin/kramers.o      \
	bin/plugflow.o     \
	bin/thermo.o

TESTS        = \
	bin/test_coefficients \
	bin/test_kinetics     \
	bin/test_kramers      \
	bin/test_plugflow     \
	bin/test_thermo

#######################################################################
# ALL
#######################################################################

all: $(BIN_DIR) $(MODULES) $(TESTS)

#######################################################################
# WORKFLOW
#######################################################################

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

venv:
	python3 -m venv venv && . venv/bin/activate && pip install ford

doc: venv
	. venv/bin/activate && ford $(PWD)/docs/src/index.md -r 0.0.1

test: $(TESTS)
	@ ./bin/test_coefficients
	@ ./bin/test_kinetics
	@ ./bin/test_kramers
	@ ./bin/test_plugflow
	@ ./bin/test_thermo

bin/kiln.a: $(MODULES)
	ar rcs bin/kiln.a bin/*.o

#######################################################################
# MODULES
#######################################################################

bin/coefficients.o: src/core/coefficients.f90
	$(FC) $(FCFLAGS) -c src/core/coefficients.f90 -o bin/coefficients.o

bin/kinetics.o: src/core/kinetics.f90
	$(FC) $(FCFLAGS) -c src/core/kinetics.f90 -o bin/kinetics.o

bin/kramers.o: src/core/kramers.f90
	$(FC) $(FCFLAGS) -c src/core/kramers.f90 -o bin/kramers.o

bin/plugflow.o: src/core/plugflow.f90
	$(FC) $(FCFLAGS) -c src/core/plugflow.f90 -o bin/plugflow.o

bin/thermo.o: src/core/thermo.f90
	$(FC) $(FCFLAGS) -c src/core/thermo.f90 -o bin/thermo.o

#######################################################################
# TESTS
#######################################################################

bin/test_coefficients: bin/kiln.a test/test_coefficients.f90
	$(FC) $(FCFLAGS) test/test_coefficients.f90 bin/kiln.a -o bin/test_coefficients

bin/test_kinetics: bin/kiln.a test/test_kinetics.f90
	$(FC) $(FCFLAGS) test/test_kinetics.f90 bin/kiln.a -o bin/test_kinetics

bin/test_kramers: bin/kiln.a test/test_kramers.f90
	$(FC) $(FCFLAGS) test/test_kramers.f90 bin/kiln.a -o bin/test_kramers

bin/test_plugflow: bin/kiln.a test/test_plugflow.f90
	$(FC) $(FCFLAGS) test/test_plugflow.f90 bin/kiln.a -o bin/test_plugflow

bin/test_thermo: bin/kiln.a test/test_thermo.f90
	$(FC) $(FCFLAGS) test/test_thermo.f90 bin/kiln.a -o bin/test_thermo

#######################################################################
# CLEAN
#######################################################################

clean:
	rm -rf $(BIN_DIR) src/core/*.mod

dist-clean: clean
	rm -rf docs/build/ venv/

#######################################################################
# EOF
#######################################################################