# -*- coding: utf-8 -*-
using CairoMakie
using DelimitedFiles
using DataFrames

function get_column_names(filename; verbose = false, newline = nothing)
    metadata = read(filename, String)
    verbose && @info(metadata)

    if isnothing(newline)
        newline = Sys.iswindows() ? "\r\n" : "\n"
    end

    lines = split(metadata, newline)
    lines = filter(l->occursin(r"^(\s+)(\d+):.", l), lines)
    map(l->match(r"^\s+\d+:\s+(?<x>(.+))", l)["x"], lines)
end

function load_table(results; fname = "sides.dat")
    head = get_column_names(joinpath(results, "$(fname).names"))
    data = readdlm(joinpath(results, fname))
    return DataFrame(data, head)
end

function workflow()
    data1 = load_table("monophase/results")
    data2 = load_table("multiphase/results")

    x1 = 1000data1[:, "coordinate 1"]
    x2 = 1000data2[:, "coordinate 1"]

    y1 = data1[:, "temperature"]
    y2 = data2[:, "temperature"]

    with_theme() do
        f = Figure()
        ax = Axis(f[1, 1])

        lines!(ax, x1, y1; color = :black, label = "Reference")
        lines!(ax, x2, y2; color = :red,   label = "Phase change")

        ax.xlabel = "Position [mm]"
        ax.ylabel = "Temperature [K]"

        ax.xticks = 0:10:100
        # ax.yticks = 0:10:100

        xlims!(ax, extrema(ax.xticks.val))
        # ylims!(ax, extrema(ax.yticks.val))

        f
    end
end
