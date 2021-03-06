# ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров
# РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток

using HorizonSideRobots

include("../jujuju.jl")

function sol10!(r)
    t = ismarker(r) * temperature(r)
    side = Ost
    k = 0
    start = false
    while !isborder(r, side) || !start
        while bool(MOVE!(r, side))
            if ismarker(r)
                t += temperature(r)
            end
        end
        if ismarker(r)
            t += temperature(r)
        end
        if bool(MOVE!(r, Nord))
            side = opposite_side(side)
            move!(r, Nord)
        end
    end
    return t
end
println("OK")