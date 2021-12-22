# ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
# РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы

using HorizonSideRobots

include("../jujuju.jl")

function marksq!(r)
    s = movve!(r, West)
    markline!(r, Nord)
    k = 0
    while !isborder(r, Ost)
        move!(r, Ost)
        markline!(r, Nord)
        k += 1
    end
    movven!(r, West, k - s)
end
println("OK")