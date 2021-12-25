# Найти маркер, когда есть перегородки - бесконечные лучи

using HorizonSideRobots

include("../jujuju.jl")

function find_marker19!(r, side, n)
    k = 0
    c = 1
    if ismarker(r)
        return true
    else
        while k <= n && !ismarker(r) && c != 0
            c = passer!(r, side)
            k += c
        end
        if k <= n 
            return ismarker(r)
        else
            return false
        end
    end
end

function sol19!(r)
    k = false
    l = 1
    side = Nord
    while !k
        k = find_marker19!(r, side, l)
        side = next_side(side)
        k = find_marker19!(r, side, l)
        side = next_side(side)
        l += 1
    end
end
println("OK")