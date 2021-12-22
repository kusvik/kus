# ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров
# РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток

using HorizonSideRobots

include("../jujuju.jl")

function sol10!(r)
    t = 0
    side = Ost
    k = 0
    while !isborder(r, side)
        while !isborder(r, side)
            if ismarker(r)
                t += temperature(r)
            end
            move!(r, side)
        end
        if ismarker(r)
            t += temperature(r)
        end
        if !isborder(r, Nord)
            side = opposite_side(side)
            move!(r, Nord)
        end
    end
    return t
end
println("OK")