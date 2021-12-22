# Рандомное место с перегородками
# Крест и вернуться

using HorizonSideRobots

include("../jujuju.jl")

function sol14!(r)
    a, s = CORNER!(r)
    movvenm!(r, a, s)
    MARK_FKN_LINE!(r, Nord)
    back_to_xy!(r, a, s)
    MARK_FKN_LINE!(r, West)
    back_to_xy!(r, a, s)
end
println("OK")