# Learn Haskell

## Using GHCi

## Creating a stack project

```bash
# Create a new project and enter its directory:
stack new kinetics-oxidation-iron
cd kinetics-oxidation-iron

# Build and execute the project (notice the `-exe`):
stack build
stack exec kinetics-oxidation-iron-exe
```

```bash
stack exec kinetics-oxidation-iron-exe `
    -- 1e-12 300 1473 0.002 0 150e-09 3 100 0.1
```

| | |
|---|---|
| .stack-work                   | Stack managed
| app                           | As you progress
| src                           | As you progress
| test                          | As you progress
| .gitignore                    | As you progress
| CHANGELOG.md                  | As you progress
| kinetics-oxidation-iron.cabal | Stack managed
| LICENSE                       | Check on creation
| package.yaml                  | Stack managed / user editable
| README.md                     | As you progress
| Setup.hs                      | Leave as is
| stack.yaml                    | Leave as is
| stack.yaml.lock               | Leave as is
