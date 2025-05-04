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
	using Symbolics

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
		f
	
		function RandomPoreModel(S₀, ε₀, L₀, dₚ)
			ε = 1 - ε₀
			σ = dₚ * S₀ / 2ε
			Ψ = 4π * L₀ * ε / S₀^2
			f = S₀ / ε
			return new(σ, Ψ, f)
		end
	end

	function (self::RandomPoreModel)(t, r)
		τ = self.f * r * t
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
		f
	
		function ChangingGrainModel(S₀, ε₀)
			return new(S₀ / (3 * (1 - ε₀)))
		end
	end

	function ChangingGrainModel(S_BET, PV₀, ρ)
		ε₀ = initial_porosity_cgm(PV₀, ρ)
		S₀ = initial_surface_cgm(S_BET, ρ, ε₀)
		return ChangingGrainModel(S₀, ε₀)
	end
	
	function (self::ChangingGrainModel)(t, r)
		return 1 - (1 - self.f * r * t)^3
	end
end

# ╔═╡ 9eea3067-382c-47b4-bfde-be2965eda71f
begin
	@info("UniformConversionModel")

	function initial_surface_ucm(S_BET, ρ)
		return 1.0e+06S_BET * ρ
	end

	struct UniformConversionModel
		f
	
		function UniformConversionModel(S₀)
			return new(S₀)
		end
	end

	function UniformConversionModel(S_BET, ρ)
		S₀ = initial_surface_ucm(S_BET, ρ)
		return UniformConversionModel(S₀)
	end

	function (self::UniformConversionModel)(t, r)
		return 1 - exp(-self.f * r * t)
	end
end

# ╔═╡ 2741ec7a-d850-4937-83f6-417c167d375a
function make_derivative(func)
	@variables t
	Dt = Differential(t)
	df = expand_derivatives(Dt(func(t)))
	return build_function(df, t; expression = Val{false})
end

# ╔═╡ 84b73266-51f8-4a14-931c-e349b25c33d4
rpm = let
	# Initial pore length [m/m³]:
	L₀ = 1.94e+13

	# Initial porosity (bad units in paper!) [-]:
	ε₀ = 0.0043

	# Initial surface area [m²/m³]:
	S₀ = 6.526e+05

	# Particle diameter [m]:
	dₚ = 6.0e-05

	RandomPoreModel(S₀, ε₀, L₀, dₚ)
end

# ╔═╡ 68b40d4b-e745-4378-a0b0-e7d3a2b3f167
cgm = ChangingGrainModel(S_BET, PV₀, ρ)

# ╔═╡ 0944a702-de96-4631-a8f7-3e375bb91836
ucm = UniformConversionModel(S_BET, ρ)

# ╔═╡ 58c764df-0077-46d1-802f-ad9f38cc086b
with_theme() do
	t = LinRange(0, 60, 300)
	f_rpm(t) = rpm(t, 8.3e-09)
	f_cgm(t) = cgm(t, 37.4e-09)
	f_ucm(t) = ucm(t, 47.4e-09)

	d_rpm = make_derivative(f_rpm)
	d_cgm = make_derivative(f_cgm)
	d_ucm = make_derivative(f_ucm)
	
	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	lines!(ax1, t, f_rpm.(t); label = "RPM", color = :black, linestyle = :dash)
	lines!(ax1, t, f_cgm.(t); label = "CGM", color = :red,   linestyle = :solid)
	lines!(ax1, t, f_ucm.(t); label = "UCM", color = :black, linestyle = :dot)

	lines!(ax2, t, d_rpm.(t); label = "RPM", color = :black, linestyle = :dash)
	lines!(ax2, t, d_cgm.(t); label = "CGM", color = :red,   linestyle = :solid)
	lines!(ax2, t, d_ucm.(t); label = "UCM", color = :black, linestyle = :dot)

	ax1.xlabel = "Time (s)"
	ax2.xlabel = "Time (s)"

	ax1.ylabel = "X"
	ax2.ylabel = "dX/dt (1/s)"

	xticks = 0.0:10.0:60.0
	xlims = extrema(xticks)
	
	ax1.xticks = xticks
	ax2.xticks = xticks
	
	ax1.yticks = 0.0:0.2:1.0
	ax2.yticks = 0.0:0.02:0.08

	xlims!(ax1, xlims)
	xlims!(ax2, xlims)
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rb)

	f
end

# ╔═╡ Cell order:
# ╟─bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
# ╟─b27dd32b-bc5d-461d-b222-af518ed0bf0f
# ╟─b2a3f168-5820-4e55-b5ee-94843bf7d2e0
# ╟─9bc5696a-50e6-49d1-8969-3c48835b398b
# ╟─22fecd51-5455-4493-92b9-1e9a7c766e97
# ╟─9eea3067-382c-47b4-bfde-be2965eda71f
# ╟─2741ec7a-d850-4937-83f6-417c167d375a
# ╟─84b73266-51f8-4a14-931c-e349b25c33d4
# ╟─68b40d4b-e745-4378-a0b0-e7d3a2b3f167
# ╟─0944a702-de96-4631-a8f7-3e375bb91836
# ╟─58c764df-0077-46d1-802f-ad9f38cc086b
