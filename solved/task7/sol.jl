# Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)
# РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке

using HorizonSideRobots

include("../jujuju.jl")

function sol7!(r)
    s, d = corner!(r)
    if (s + d) % 2 == 0
        k = 0
    else
        k = 1
    end
    side = Nord
    while !isborder(r, West)
        chessline!(r, side, k)
        move!(r, West)
        k += 1
        side = opposite_side(side)
    end
    chessline!(r, side, k)
    corner!(r)
    movvenm!(r, s, d)
end
println('OK')