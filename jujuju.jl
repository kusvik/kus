using HorizonSideRobots

opposite_side(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)
next_side(side::HorizonSide) = HorizonSide((Int(side) + 1) % 4)
previous_side(side::HorizonSide) = HorizonSide((Int(side) + 3) % 4)

function around!(r, side)
    s = 0
    while isborder(r, side)
        side = next_side(side)
        s += 1
    end
    return side, s
end

function MOVE!(r, side)
    if side == Nord
        y1 = 1
        x1 = 0
    elseif side == Ost
        y1 = 0
        x1 = 1
    elseif side == West
        y1 = 0
        x1 = -1
    else
        y1 = -1
        x1 = 0
    end
    side, s = around!(r, side)
    side0 = side
    x = 0
    y = 0

    x2 = 0
    y2 = 0 # будущие координаты близжайжей доступной точки на прямой side
    
    breakk = 0
    d = 0
    g = 0
    side2 = side
    side0 = side
    while (x1 != x || y1 != y) && d <= 1 && g != 2
        move!(r, side)
        if side == Nord
            y += 1
        elseif side == Ost
            x += 1
        elseif side == West
            x -= 1
        else
            y -= 1
        end
        side = previous_side(side)
        side, s = around!(r, side)
        if ((x == 0 && x1 == 0) || (y == 0 && y1 == 0)) && (abs(y2 + x2) > abs(x + y) || x2 + y2 == 0) && x*x1 + y*y1 > 0
            x2, y2 = x, y
            g = 0
            side2 = side
        end
        if x2 == x && y2 == y && side2 == side
            g += 1
        end
    end
    return x == x1 && y == y1
end

function ray!(r, side)
    s = 0
    putmarker!(r)
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        s += 1 
    end
    return s
end

function rayn!(r, side, n)
    k = 1
    putmarker!(r)
    while k != n && !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        k += 1
    end
    return k == n
end

function markline!(r, side)
    s = 1 + ray!(r, side) - ray!(r, opposite_side(side))
    while s <= 0
        move!(r, side)
        s += 1
    end
end

function MARK_FKN_LINE!(r, side)
    while MOVE!(r, side)
        putmarker!(r)
    end

    while MOVE!(r, opposite_side(side))
        putmarker!(r)
    end
end

function movve!(r, side)
    s = 0
    while !isborder(r, side)
        move!(r, side)
        s += 1 
    end
    return s
end

function movven!(r, side, n)
    s = 0
    if n < 0
        side = opposite_side(side)
        n = -n
    end
    while s < n
        MOVE!(r, side)
        s += 1
    end
end

function movvenm!(r, n, m)
    side1 = Nord
    side2 = West
    if n < 0 
        side1 = Sud
        n = -n
    end
    if m < 0
        side2 = Ost
        m = -m
    end
    movven!(r, side1, n)
    movven!(r, side2, m)
end

function corner!(r)
    f = movve!(r, Sud)
    d = movve!(r, Ost)
    return f, d
end

function difcorner!(r, n)
    n = n % 4
    k = 0
    side = Ost
    while n != k
        k += 1
        side = next_side(side)
    end
    s = movve!(r, side)
    d = movve!(r, previous_side(side))
    if k == 1
        d, s = -s, d
    elseif k == 2
        s, d = -s, -d
    elseif k == 3
        d, s = s, -d
    end
    return d, s
end

function CORNER!(r)
    f = 0
    d = 0
    while MOVE!(r, Sud)
        f += 1
    end
    while MOVE!(r, Ost)
        d += 1
    end
    return f, d
end

function isb!(r, side, n)
    while n != 0 && !isborder(r, side)
        move!(r, side)
        n -= 1
    end
    if n == 0
        return 0
    else
        return n
    end
end

function markwall!(r, side, f) # f - показывает в какую сторону маркировать, направо от стенки или, если f <= 0, налево
    k = 0
    if !bool(f) 
        side2 = next_side(side)
    else
        side2 = previous_side(side)
    end
    while isborder(r, side)
        putmarker!(r)
        move!(r, side2)
        k += 1
    end
    return k
end

function bool(n)
    if n > 0 
        return true
    else
        return false
    end
end

function chessline!(r, side, k) # k определяет будет ли раскраска ч/б или б/ч
    while !isborder(r, side)
        if k % 2 == 0
            putmarker!(r)
        end
        MOVE!(r, side)
        k += 1
    end
    if k % 2 == 0
        putmarker!(r)
    end
end

function find_marker!(r, side, n)
    k = 0
    if ismarker(r)
        return true
    else
        while k != n && !ismarker(r)
            k += 1
            MOVE!(r, side)
        end
        return ismarker(r)
    end
end

function back_to_xy!(r, x, y)
    CORNER!(r)
    movvenm!(r, x, y)
end
