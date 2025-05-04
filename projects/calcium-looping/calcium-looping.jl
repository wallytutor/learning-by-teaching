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
	using Match
	using ModelingToolkit
	using Symbolics
end;

# ╔═╡ b27dd32b-bc5d-461d-b222-af518ed0bf0f
begin
	@info("Global numerical parameters...")
	
	# Reactor length and diameter [m]:
	# L = 0.015
	# D = 0.010

	# Gas hourly space velocity [1/hr]:
	# GHSV = 22500

	# Molar mass of CaCO3 [g/mol]
	# M = 100.09

	# Reactor volume [m³]:
	# V = π * D^2 * L / 4

	# Flow rate [m³/s]:
	# Q = (GHSV / 3600) * V

	# Molar volume of CaCO3 [cm³/mol]:
	# Vm = M / ρ

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

# ╔═╡ e48c8a2f-5c13-4890-8247-971bcad7e123
begin
	@info("CalcinationRate")

	@enum CalcinationRateTypes begin
	    LangmuirHinshelwood
	    ExponentialFit
	end
	
	equilibrium_co2(T) = 413.7e+07exp(-20474/T)

	k1lh_ucm(T) = exp(27.271 - 25335/T)
	k1lh_cgm(T) = exp(27.798 - 26155/T)

	Kprime_ucm(T) = exp(12216/T - 13.49)
	Kprime_cgm(T) = exp(10959/T - 12.31)

	k1E_ucm(T) = exp(27.860 - 26016/T)
	k1E_cgm(T) = exp(23.892 - 21751/T)
	
	KE_ucm(T) = exp(5.789 - 5067.5/T)
	KE_cgm(T) = exp(3.193 - 2099.3/T)

	function coverage_co2(T, P_CO2, K_func)
		f = K_func(T) * P_CO2
		return 
	end

	struct CalcinationRate{T}
		k1::Function
		Kp::Function
		
		function CalcinationRate{T}(model) where T
			if !(model ∈ [:UCM, :CGM])
				error("Model not implemented $(model)")
			end
			
			k1, Kp = if T == LangmuirHinshelwood
				@match model begin
					:UCM => (k1lh_ucm, Kprime_ucm)
					:CGM => (k1lh_cgm, Kprime_cgm)
				end
			elseif T == ExponentialFit
				@match model begin
					:UCM => (k1E_ucm, KE_ucm)
					:CGM => (k1E_cgm, KE_cgm)
				end 
			end

			return new(k1, Kp)
			
		end
	end

	function (self::CalcinationRate{LangmuirHinshelwood})(T, P_CO2)
		k1 = self.k1(T) # Vm embeded here!
		Kp = self.Kp(T)

		f = Kp * P_CO2
		θ = f / (1 + f) 
		r = P_CO2 / equilibrium_co2(T)
		
		return k1 * (1 - θ) * (1 - r)
	end
	
	function (self::CalcinationRate{ExponentialFit})(T, P_CO2)
		r = P_CO2 / equilibrium_co2(T)
		return self.k1(T) * exp(-self.Kp(T) * r)
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
	axislegend(ax2; position = :rt)

	f
end

# ╔═╡ 3bc1abd3-714b-4a3d-8a25-3676f4914162
with_theme() do
	T = LinRange(800, 900, 100) .+ 273.15
	I = 1000 ./ T

	f_k1lh_ucm = log.(k1lh_ucm.(T))
	f_k1lh_cgm = log.(k1lh_cgm.(T))
	
	f_Kprime_ucm = log.(Kprime_ucm.(T))
	f_Kprime_cgm = log.(Kprime_cgm.(T))

	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	lines!(ax1, I, f_k1lh_ucm; label = "UCM", color = :black)
	lines!(ax1, I, f_k1lh_cgm; label = "CGM", color = :red)

	lines!(ax2, I, f_Kprime_ucm; label = "UCM", color = :black)
	lines!(ax2, I, f_Kprime_cgm; label = "CGM", color = :red)

	ax1.xlabel = "1000 / T (1000 / K)"
	ax2.xlabel = "1000 / T (1000 / K)"

	ax1.ylabel = L"\ln(k_{1L-H})"
	ax2.ylabel = L"\ln(K\prime)"

	xticks = 0.86:0.01:0.92
	xlims = extrema(xticks)
	
	ax1.xticks = xticks
	ax2.xticks = xticks
	
	ax1.yticks = 3.6:0.4:5.6
	ax2.yticks = -3.0:0.2:-2.2

	xlims!(ax1, xlims)
	xlims!(ax2, xlims)
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rt)
	axislegend(ax2; position = :rb)

	f
end

# ╔═╡ 8d293f44-6fe4-42f5-ac83-adce0c3eab85
with_theme() do
	cgm_rt = CalcinationRate{LangmuirHinshelwood}(:CGM)
	ucm_rt = CalcinationRate{LangmuirHinshelwood}(:UCM)
	
	P = LinRange(0, 100, 100)
	T = [(825, :green), (845, :blue), (870, :red), (885, :black)]
	
	
	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	for (Tc, color) in T
		f_ucm(P) = ucm_rt(Tc+273.15, P)
		lines!(ax1, P, f_ucm.(P); label = "$(Tc) °C", color)
	end

	for (Tc, color) in T
		f_cgm(P) = cgm_rt(Tc+273.15, P)
		lines!(ax2, P, f_cgm.(P); label = "$(Tc) °C", color)
	end

	ax1.title = "UCM"
	ax2.title = "CGM"
	
	ax1.xlabel = L"P_{\mathrm{CO_2}}\:\mathrm{(kPa)}"
	ax2.xlabel = L"P_{\mathrm{CO_2}}\:\mathrm{(kPa)}"

	ax1.ylabel = L"r\:\mathrm{(nm/s)}"
	ax2.ylabel = L"r\:\mathrm{(nm/s)}"

	xticks = 0.0:20.0:100.0
	xlims = extrema(xticks)
	
	ax1.xticks = xticks
	ax2.xticks = xticks
	
	ax1.yticks = 0.0:40.0:240.0
	ax2.yticks = 0.0:40.0:200.0

	xlims!(ax1, xlims)
	xlims!(ax2, xlims)
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rt)
	axislegend(ax2; position = :rt)

	f
end

# ╔═╡ 5c66c737-2c5c-4190-9dc5-a8d510632fa2
with_theme() do
	cgm_rt = CalcinationRate{LangmuirHinshelwood}(:CGM)
	ucm_rt = CalcinationRate{LangmuirHinshelwood}(:UCM)

	T = [(845, :blue), (870, :red), (885, :black)]

	function add_to_axis(ax, P, tmax)
		t = LinRange(0, tmax, convert(Int, round(tmax)))
		
		for (Tc, color) in T
			r_cgm = cgm_rt(Tc+273.15, P)
			r_ucm = ucm_rt(Tc+273.15, P)
	
			f_cgm(t) = cgm(t, r_cgm * 1e-09)
			f_ucm(t) = ucm(t, r_ucm * 1e-09)
			
			lines!(ax, t, f_cgm.(t); label = "$(Tc) °C", color, linestyle = :solid)
			lines!(ax, t, f_ucm.(t); color, linestyle = :dash)
		end
	end
	
	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	add_to_axis(ax1, 10.1, 60)
	add_to_axis(ax2, 30.4, 140)

	ax1.title = L"P_\mathrm{CO_2} = 10.1\:\mathrm{kPa}"
	ax2.title = L"P_\mathrm{CO_2} = 30.4\:\mathrm{kPa}"
	
	ax1.xlabel = "Time (s)"
	ax2.xlabel = "Time (s)"

	ax1.ylabel = "X"
	ax2.ylabel = "X"

	ax1.xticks = 0.0:10.0:60.0
	ax2.xticks = 0.0:20.0:140.0
	
	ax1.yticks = 0.0:0.2:1.0
	ax2.yticks = 0.0:0.2:1.0

	xlims!(ax1, extrema(ax1.xticks.val))
	xlims!(ax2, extrema(ax2.xticks.val))
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rb)
	axislegend(ax2; position = :rb)

	f
end

# ╔═╡ 5d1bfc83-a06c-4226-9f51-037ea58a7ea4
with_theme() do
	T = LinRange(800, 900, 100) .+ 273.15
	I = 1000 ./ T

	f_k1E_ucm = log.(k1E_ucm.(T))
	f_k1E_cgm = log.(k1E_cgm.(T))
	
	f_KE_ucm = log.(KE_ucm.(T))
	f_KE_cgm = log.(KE_cgm.(T))

	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	lines!(ax1, I, f_k1E_ucm; label = "UCM", color = :black)
	lines!(ax1, I, f_k1E_cgm; label = "CGM", color = :red)

	lines!(ax2, I, f_KE_ucm; label = "UCM", color = :black)
	lines!(ax2, I, f_KE_cgm; label = "CGM", color = :red)

	ax1.xlabel = "1000 / T (1000 / K)"
	ax2.xlabel = "1000 / T (1000 / K)"

	ax1.ylabel = L"\ln(k_{1E})"
	ax2.ylabel = L"\ln(K_E)"

	xticks = 0.86:0.01:0.92
	xlims = extrema(xticks)
	
	ax1.xticks = xticks
	ax2.xticks = xticks
	
	ax1.yticks = 4.0:0.2:5.6
	ax2.yticks = 1.15:0.05:1.45

	xlims!(ax1, xlims)
	xlims!(ax2, xlims)
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rt)
	axislegend(ax2; position = :rb)

	f
end

# ╔═╡ dd4d9557-ef02-49cf-9b46-20f0e4f37228
with_theme() do
	cgm_rt = CalcinationRate{ExponentialFit}(:CGM)
	ucm_rt = CalcinationRate{ExponentialFit}(:UCM)
	
	P = LinRange(0, 100, 100)
	T = [(825, :green), (845, :blue), (870, :red), (885, :black)]
	
	
	f = Figure(size = (680, 300))
	ax1 = Axis(f[1, 1]; xgridstyle = :dot, ygridstyle = :dot)
	ax2 = Axis(f[1, 2]; xgridstyle = :dot, ygridstyle = :dot)

	for (Tc, color) in T
		f_ucm(P) = ucm_rt(Tc+273.15, P)
		lines!(ax1, P, f_ucm.(P); label = "$(Tc) °C", color)
	end

	for (Tc, color) in T
		f_cgm(P) = cgm_rt(Tc+273.15, P)
		lines!(ax2, P, f_cgm.(P); label = "$(Tc) °C", color)
	end

	ax1.title = "UCM"
	ax2.title = "CGM"
	
	ax1.xlabel = L"P_{\mathrm{CO_2}}\:\mathrm{(kPa)}"
	ax2.xlabel = L"P_{\mathrm{CO_2}}\:\mathrm{(kPa)}"

	ax1.ylabel = L"r\:\mathrm{(nm/s)}"
	ax2.ylabel = L"r\:\mathrm{(nm/s)}"

	xticks = 0.0:20.0:100.0
	xlims = extrema(xticks)
	
	ax1.xticks = xticks
	ax2.xticks = xticks
	
	ax1.yticks = 0.0:40.0:240.0
	ax2.yticks = 0.0:40.0:200.0

	xlims!(ax1, xlims)
	xlims!(ax2, xlims)
	
	ylims!(ax1, extrema(ax1.yticks.val))
	ylims!(ax2, extrema(ax2.yticks.val))

	axislegend(ax1; position = :rt)
	axislegend(ax2; position = :rt)

	f
end

# ╔═╡ Cell order:
# ╟─bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
# ╟─b27dd32b-bc5d-461d-b222-af518ed0bf0f
# ╟─9bc5696a-50e6-49d1-8969-3c48835b398b
# ╟─22fecd51-5455-4493-92b9-1e9a7c766e97
# ╟─9eea3067-382c-47b4-bfde-be2965eda71f
# ╟─e48c8a2f-5c13-4890-8247-971bcad7e123
# ╟─2741ec7a-d850-4937-83f6-417c167d375a
# ╟─84b73266-51f8-4a14-931c-e349b25c33d4
# ╟─68b40d4b-e745-4378-a0b0-e7d3a2b3f167
# ╟─0944a702-de96-4631-a8f7-3e375bb91836
# ╟─58c764df-0077-46d1-802f-ad9f38cc086b
# ╟─3bc1abd3-714b-4a3d-8a25-3676f4914162
# ╟─8d293f44-6fe4-42f5-ac83-adce0c3eab85
# ╟─5c66c737-2c5c-4190-9dc5-a8d510632fa2
# ╟─5d1bfc83-a06c-4226-9f51-037ea58a7ea4
# ╟─dd4d9557-ef02-49cf-9b46-20f0e4f37228
