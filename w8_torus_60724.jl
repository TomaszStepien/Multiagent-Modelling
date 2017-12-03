# Tasks:
# 1. What do those functions calculate?
# 
# 2. Do they produce identical results?
# see below
# 3. Compare their performance.
# see below
# 4. Generalize to n dimensions
# see below

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
# n1 - a vector containing coordinates of the first point (x1, y1, z1 etc.)
# n2 - a vector conatining coordinates of the second point (x2, y2, z2 etc.)
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

# 2: output
# first let's check results for integer inputs
rd1 = d1(1,1,100,100)
rd2 = d2(1,1,100,100)
rd3 = d3(1,1,100,100)
rd4 = d4(1,1,100,100)

# do they give the same results?
rd3 == rd2 == rd1 == rd4 
# true
# results appear to be the same, but let's examine them with more strict comparison
rd3 === rd2 === rd1 === rd4
# false
rd3 === rd2 === rd1
# true
# calculations in functions d4 include real non-integer numbers so function 
# produces real output. Functions d1, d2, d3 produce integer output. 

# now for real inputs
rd1 = d1(1.5,1.5,100.5,100.5)
rd2 = d2(1.5,1.5,100.5,100.5)
rd3 = d3(1.5,1.5,100.5,100.5)
rd4 = d4(1.5,1.5,100.5,100.5)

# do they give the same results?
rd3 == rd2 == rd1 == rd4
# true
rd3 === rd2 === rd1 === rd4
# true
# now both test give true so results are the same 

# 3: performance - when run again results may differ slightly
@time d1(1,1,100,100)
# 0.000005 seconds (12 allocations: 560 bytes)
@time d2(1,1,100,100)
# 0.000008 seconds (10 allocations: 416 bytes)
@time d3(1,1,100,100)
# 0.000006 seconds (23 allocations: 464 bytes)
@time d4(1,1,100,100)
# 0.000006 seconds (14 allocations: 320 bytes)

@time dn4(1:1000, 2001:3000)
# 0.000054 seconds (5.01 k allocations: 78.344 KiB)
@time dn5(1:1000, 2001:3000)
# 0.001115 seconds (26.96 k allocations: 562.031 KiB)
