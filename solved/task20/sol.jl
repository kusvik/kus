# Количество вертикальных перегородок

using HorizonSideRobots

include("../jujuju.jl")

function sol20!(r)
    CORNER!(r)
    c = 0
    while !isborder(r, West)
        s = 0
        while !isborder(r, Nord)
            s0 = s 
            if isborder(r, West)
                s = 1
            else
                s = 0
            end
            if s0 == 0 && s == 1
                c += 1
            end
            move!(r, Nord)
        end
        move!(r, West)
        movve!(r, Sud)
    end
    return c
end
println("OK")