# Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, в которой имеется проход шириной в одну клетку.
# РЕЗУЛЬТАТ: Робот - в клетке под проходом

using HorizonSideRobots

include("../jujuju.jl")

function sol8!(r)
    k = 1
    side = West
    while isborder(r, Nord)
        movven!(r, side, k)
        side = opposite_side(side)
        k += 1
    end
end
println("OK")