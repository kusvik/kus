# Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки (все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)
# РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры

using HorizonSideRobots

include("../jujuju.jl")

function sol5!(r)
    s, d = CORNER!(r)

    putmarker!(r)
    MOVVE!(r, Nord)
    putmarker!(r)
    MOVVE!(r, West)
    putmarker!(r)
    MOVVE!(r, Sud)
    putmarker!(r)
    MOVVE!(r, Ost)
    back_to_xy!(r, s, d)
end
println("OK")