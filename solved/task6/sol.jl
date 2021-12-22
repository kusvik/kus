# ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. Робот - в произвольной клетке поля между внешней и внутренней перегородками. 
# РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру внутренней перегородки поставлены маркеры.

using HorizonSideRobots

include("../jujuju.jl")

function sol6!(r)
    s, d = CORNER!(r)
    x = movve!(r, Nord)
    side  = Sud
    while !bool(isb!(r, side, x))
        move!(r, West)
        side = opposite_side(side)
    end
    println(side)
    for i = 1:5
        markwall!(r, side, 1)
        putmarker!(r)
        move!(r, side)
        side = next_side(side)
    end
    CORNER!(r)
    movvenm!(r, s, d)
end
println("OK")