# Tasks:
# 1. What do those functions calculate?
# 2. Do they produce identical results?
# 3. Compare their performance.

function d1(x1, y1, x2, y2)
    minimum((x1-x2+u1)^2+(y1-y2+u2)^2 for u1 in [-1, 0, 1], u2 in [-1, 0, 1])
end

function d2(x1, y1, x2, y2)
    minimum((x1-x2+u1)^2+(y1-y2+u2)^2 for u1 in -1:1, u2 in -1:1)
end

function d3(x1, y1, x2, y2)
    m = Inf
    for u1 in -1:1, u2 in -1:1
        v = (x1-x2+u1)^2+(y1-y2+u2)^2
        if v < m
            m = v
        end
    end
    m
end

function d4(x1, y1, x2, y2)
    dx = x1-x2
    if dx > 0.5
        dx = 1.0 - dx
    elseif dx < -0.5
        dx = 1.0 + dx
    end
    dx *= dx
    dy = y1-y2
    if dy > 0.5
        dy = 1.0 - dy
    elseif dy < -0.5
        dy = 1.0 + dy
    end
    dy *= dy

    dx + dy
end

# Homework: generalize the code to any dimension
function dn4(n1, n2)
    res = 0
    for i in 1:length(n1)
        dn = n1[i] - n2[i]
        if dn > 0.5
            dn = 1.0 - dn
        elseif dn < -0.5
            dn = 1.0 + dn
        end
        res += dn^2
    end
    res
end

function dn5(n1, n2)
    v = 0
    for i in 1:length(n1)
        v += minimum((n1[i] - n2[i] + u)^2 for u in -1:1)
    end
    v
end


@time d1(1,1,100,100)
@time d2(1,1,100,100)
@time d3(1,1,100,100)
@time d4(1,1,100,100)

@time dn4(1:1000, 2001:3000)
@time dn5(1:1000, 2001:3000)
