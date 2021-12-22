# ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. Робот - в произвольной клетке поля.
# РЕЗУЛЬТАТ: Робот - в клетке с тем маркером.

using HorizonSideRobots

include("../jujuju.jl")

function sol9!(r)
    k = false
    l = 1
    side = Nord
    while !k
        k = find_marker!(r, side, l)
        side = next_side(side)
        k = find_marker!(r, side, l)
        side = next_side(side)
        l += 1
    end
end
println("OK")