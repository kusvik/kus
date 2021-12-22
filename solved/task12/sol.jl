# На прямоугольном поле произвольных размеров расставить маркеры в виде "шахматных" клеток, начиная с юго-западного угла поля, когда каждая отдельная "шахматная" клетка имеет размер n x n клеток поля (n - это параметр функции). Начальное положение Робота - произвольное, конечное - совпадает с начальным. Клетки на севере и востоке могут получаться "обрезанными" - зависит от соотношения размеров поля и "шахматных" клеток. (Подсказка: здесь могут быть полезными две глобальных переменных, в которых будут содержаться текущие декартовы координаты Робота относительно начала координат в левом нижнем углу поля, например)

using HorizonSideRobots

include("../jujuju.jl")

function liniya!(r, n)
    k = 4
    while k != 0 && !isborder(r, Ost)
        rayn!(r, Ost, n)
        isb!(r, Ost, n+ 1)
        k -= 1
    end
    movve!(r, West)
end

function sol12!(r, n)
    s, d = difcorner!(r, 3)
    x = 0
    while !isborder(r, Nord) && !isborder(r, Ost) && x != 4
        k = 1
        liniya!(r, n)
        movve!(r, West)
        while k != n && !isborder(r, Nord)
            move!(r, Nord)
            liniya!(r, n)
            k += 1
        end
        k = 0
        while k != n && !isborder(r, Nord)
            move!(r, Nord)
            k += 1
            movven!(r, Ost, n)
            liniya!(r, n)
        end
        x += 1
        if !isborder(r, Nord)
            move!(r, Nord)
        end
    end
    difcorner!(r, 3)
    movvenm!(r, s, d)
end
println("OK")