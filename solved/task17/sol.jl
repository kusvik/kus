# Есть рамки
# Лесенка

using HorizonSideRobots

include("../jujuju.jl")

function sol17!(r)
    f, d = CORNER!(r)
    MARK_FKN_LINE!(r, West)
    c = 1
    s = 0
    MOVE!(r, Nord)
    while c != 0
        s += 1
        RAY!(r, West)
        MOVVE!(r, Ost)
        c = MOVE!(r, Nord)
        movven!(r, West, s)
    end
    back_to_xy!(r, f, d)
end
println("OK")