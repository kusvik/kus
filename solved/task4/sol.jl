# ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля
# РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь, за исключением одной последней клетки на Востоке, следующий - за исключением двух последних клеток на Востоке, и т.д.

using HorizonSideRobots

include("../jujuju.jl")

function sol4!(r)
    f, d = corner!(r)
    markline!(r, West)
    k = 0
    l = 0
    while !isborder(r, Nord)
        move!(r, Nord)
        s = ray!(r, West)
        movven!(r, Ost, s - 1)
        k += 1
        if isborder(r, West)
            l += 1
        end
    end
    corner!(r)
    movvenm!(r, f, d)
end
println("OK")