### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
begin
	@info("Importing tools...")
	
	using Pkg

	function projectivate(path; logfile = "activation.log")
	    open(logfile, "w") do logs
	        Pkg.activate(path; io=logs)
	        Pkg.instantiate(; io=logs)
	    end
	end

	projectivate(@__DIR__)
	
	using CairoMakie
	using PythonCall
	using ModelingToolkit

	ct = pyimport("cantera")
end;

# ╔═╡ b27dd32b-bc5d-461d-b222-af518ed0bf0f
begin
	@info("Global numerical parameters...")
	
	# Reactor length and diameter [m]:
	L = 0.015
	D = 0.010

	# Gas hourly space velocity [1/hr]:
	GHSV = 22500

	# Molar mass of CaCO3 [g/mol]
	M = 0.10009

	# Density of CaCO3 [g/cm³]
	ρ = 2.711

	###
	# Limestone before 1st calcination
	###

	# BET surface area [m²/g]
	S_BET = 0.57
	
	# Pore volume [cm³/g]
	PV₀ = 0.0017
end;

# ╔═╡ b2a3f168-5820-4e55-b5ee-94843bf7d2e0
begin
	@info("Global computed parameters...")
	
	# Reactor volume [m³]:
	V = π * D^2 * L / 4

	# Flow rate [m³/s]:
	Q = (GHSV / 3600) * V

	# Molar volume of CaCO3 [cm³/mol]:
	Vm = 1 / (ρ / M)
end;

# ╔═╡ 9bc5696a-50e6-49d1-8969-3c48835b398b
begin
	@info("RandomPoreModel")

	struct RandomPoreModel
		σ
		Ψ
		τ
	
		function RandomPoreModel(S₀, ε₀, L₀, dₚ)
			f = 1 - ε₀
			σ = dₚ * S₀ / 2f
			Ψ = 4π * L₀ * f / S₀^2
			τ = S₀ / f
			return new(σ, Ψ, τ)
		end
	end

	function (self::RandomPoreModel)(t, r)
		τ = self.τ * r * t
		p = (1 - τ / self.σ)^3
		q = τ * (1 + self.Ψ * τ / 4)
		return 1 - p * exp(-q)
	end
end

# ╔═╡ 22fecd51-5455-4493-92b9-1e9a7c766e97
begin
	@info("ChangingGrainModel")

	function initial_porosity_cgm(PV₀, ρ)
		return PV₀ * ρ / (1 + PV₀ * ρ)
	end

	function initial_surface_cgm(S_BET, ρ, ε₀)
		return 1.0e+06S_BET * ρ * (1 - ε₀)
	end

	struct ChangingGrainModel
		τ
	
		function ChangingGrainModel(S₀, ε₀)
			f = 1 - ε₀
			τ = S₀ / 3f
			return new(τ)
		end
	end

	function (self::ChangingGrainModel)(t, r)
		τ = self.τ * r * t
		return 1 - (1 - τ)^3
	end
end

# ╔═╡ 9eea3067-382c-47b4-bfde-be2965eda71f
begin
	@info("UniformConversionModel")

	function initial_surface_ucm(S_BET, ρ)
		return 1.0e+06S_BET * ρ
	end

	struct UniformConversionModel
		τ
	
		function UniformConversionModel(S₀)
			return new(S₀)
		end
	end

	function (self::UniformConversionModel)(t, r)
		τ = self.τ * r * t
		return 1 - exp(-τ)
	end
end

# ╔═╡ 84b73266-51f8-4a14-931c-e349b25c33d4
let
	@info("RPM model parameters...")

	# Initial pore length [m/m³]:
	L₀ = 1.94e+13

	# Initial porosity (bad units in paper!) [-]:
	ε₀ = 0.0043

	# Initial surface area [m²/m³]:
	S₀ = 6.526e+06

	# Particle diameter [m]:
	dₚ = 6.0e-05

	# Model parameters in paper [-]:
	# σ = 19.7
	# Ψ = 570.0

	rpm = RandomPoreModel(S₀, ε₀, L₀, dₚ)
	# rpm(1.0, 1e-12)
end

# ╔═╡ 68b40d4b-e745-4378-a0b0-e7d3a2b3f167
let
	@info("CGM model parameters...")

	ε₀ = initial_porosity_cgm(PV₀, ρ)
	S₀ = initial_surface_cgm(S_BET, ρ, ε₀)

	cgm = ChangingGrainModel(S₀, ε₀)
end

# ╔═╡ 0944a702-de96-4631-a8f7-3e375bb91836
let
	@info("UCM model parameters...")

	S₀ = initial_surface_ucm(S_BET, ρ)

	ucm = UniformConversionModel(S₀)
end

# ╔═╡ Cell order:
# ╟─bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
# ╠═b27dd32b-bc5d-461d-b222-af518ed0bf0f
# ╠═b2a3f168-5820-4e55-b5ee-94843bf7d2e0
# ╟─9bc5696a-50e6-49d1-8969-3c48835b398b
# ╟─22fecd51-5455-4493-92b9-1e9a7c766e97
# ╟─9eea3067-382c-47b4-bfde-be2965eda71f
# ╟─84b73266-51f8-4a14-931c-e349b25c33d4
# ╟─68b40d4b-e745-4378-a0b0-e7d3a2b3f167
# ╟─0944a702-de96-4631-a8f7-3e375bb91836
