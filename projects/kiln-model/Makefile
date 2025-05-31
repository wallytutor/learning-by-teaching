#######################################################################
# CONFIGURATION
#######################################################################

FC           = /usr/bin/gfortran
FCFLAGS      = -O2 -Wall -Jbin

SRC_DIR      = src
BIN_DIR      = bin

MODULES      = \
	bin/coefficients.o \
	bin/kinetics.o     \
	bin/kramers.o      \
	bin/plugflow.o

TESTS        = \
	bin/test_coefficients \
	bin/test_kinetics     \
	bin/test_kramers      \
	bin/test_plugflow

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

#######################################################################
# MODULES
#######################################################################

bin/coefficients.o: src/core/coefficients.f90
	$(FC) $(FCFLAGS) -c src/core/coefficients.f90 -o bin/coefficients.o

bin/kinetics.o: src/core/kinetics.f90
	$(FC) $(FCFLAGS) -c src/core/kinetics.f90 -o bin/kinetics.o

bin/kramers.o: src/core/kramers.f90
	$(FC) $(FCFLAGS) -c src/core/kramers.f90 -o bin/kramers.o

bin/plugflow.o: src/core/kramers.f90
	$(FC) $(FCFLAGS) -c src/core/plugflow.f90 -o bin/plugflow.o

#######################################################################
# TESTS
#######################################################################

bin/test_coefficients: test/test_coefficients.f90
	$(FC) $(FCFLAGS) test/test_coefficients.f90 -o bin/test_coefficients

bin/test_kinetics: test/test_kinetics.f90
	$(FC) $(FCFLAGS) test/test_kinetics.f90 -o bin/test_kinetics

bin/test_kramers: test/test_kramers.f90
	$(FC) $(FCFLAGS) test/test_kramers.f90 -o bin/test_kramers

bin/test_plugflow: test/test_plugflow.f90
	$(FC) $(FCFLAGS) test/test_plugflow.f90 -o bin/test_plugflow

#######################################################################
# CLEAN
#######################################################################

clean:
	rm -rf $(BIN_DIR)

dist-clean: clean
	rm -rf docs/build/ venv/

#######################################################################
# EOF
#######################################################################