# ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)
# РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы

using HorizonSideRobots

include("../jujuju.jl")

function sq!(r)
    d = movve!(r, Sud)
    s = ray!(r, Ost)
    d -= ray!(r, Nord)
    s -= ray!(r, West)
    d += ray!(r, Sud)
    s += ray!(r, Ost)
    movvenm!(r, d, s)
end
println("OK")