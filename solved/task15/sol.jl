# Бот где-то. Есть рамки
# Закрасить периметр и вернуться

using HorizonSideRobots

include("../jujuju.jl")

function sol15!(r)
    a, s = CORNER!(r)
    for i in [Nord, Ost, Sud, West]
        MARK_FKN_LINE!(r, i)
    end
    back_to_xy!(r, a, s)
end
println("OK")