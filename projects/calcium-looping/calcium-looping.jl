### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
begin
	using Pkg
	
	function projectivate(path; logfile = "activation.log")
		open(logfile, "w") do logs
			Pkg.activate(path; io=logs)
			Pkg.instantiate(; io=logs)
		end
	end
	
	projectivate(@__DIR__)
	
	using CairoMakie
	using ModelingToolkit
end

# ╔═╡ b27dd32b-bc5d-461d-b222-af518ed0bf0f


# ╔═╡ b2a3f168-5820-4e55-b5ee-94843bf7d2e0


# ╔═╡ 84b73266-51f8-4a14-931c-e349b25c33d4


# ╔═╡ Cell order:
# ╠═bfbd6cf0-28a6-11f0-0e4d-47ad07a51ba6
# ╠═b27dd32b-bc5d-461d-b222-af518ed0bf0f
# ╠═b2a3f168-5820-4e55-b5ee-94843bf7d2e0
# ╠═84b73266-51f8-4a14-931c-e349b25c33d4
