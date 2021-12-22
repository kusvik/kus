# ДАНО: Робот - в произвольной клетке ограниченного прямоугольной рамкой поля без внутренних перегородок и маркеров.
# РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого креста (в форме X) из маркеров.

using HorizonSideRobots

include("../jujuju.jl")

function bad_ray!(r, side)
    while !isborder(r, side) && !isborder(r, next_side(side))
        move!(r, side)
        move!(r, next_side(side))
        putmarker!(r)
    end
end

function sol13!(r)
    a, s = corner!(r)
    movvenm!(r, a, s)
    putmarker!(r)
    bad_ray!(r, Nord)
    bad_ray!(r, Sud)
    back_to_xy!(r, a, s)
    bad_ray!(r, West)
    bad_ray!(r, Ost)
    back_to_xy!(r, a, s)
end
println("OK")