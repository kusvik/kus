# Есть рамки
# Закрасить все клетки и вернуться

using HorizonSideRobots

include("../jujuju.jl")

function sol16!(r)
    x, y = CORNER!(r)
    side = Nord
    c = 1
    while c != 0
        putmarker!(r)
        while bool(MOVE!(r, side))
            putmarker!(r)
        end
        c = MOVE!(r, West)
        side = opposite_side(side)
    end
end
println("OK")