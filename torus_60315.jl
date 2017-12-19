workspace()
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
# Tasks:
# 1. What do those functions calculate?
# Funkcje te obliczaja odleglosc pomiedzy dwoma punktami w torusie (obwarzanku)

# 2. Do they produce identical results?
result1 = d1(1,2,3,4)
result3 = d3(1,2,3,4)
result2 = d2(1,2,3,4)
result4 = d4(1,2,3,4)

println("d1: ",result1)
println("d2: ",result2)
println("d3: ",result3)
println("d4: ",result4)

result1 === result2 === result3 === result4


# Jak widac, pierwsze trzy funkcje zwracaja wynik, ktory jest liczba calowita (intiger), 
# natomiast czwarta funkcja zwraca liczby z czescia po przecinkku (float),
# wiec funkcje te nie sa identyczne

result1 = d1(1.5,2,3,4)
result2 = d1(1.5,2,3,4)
result3 = d1(1.5,2,3,4)
result4 = d1(1.5,2,3,4)

result1 === result2 === result3 === result4

# W przypadku, gdy wsrod parametrow podanych funkcji znajduje sie liczba zmiennoprzecinkowa,
# funkcje zwracaja takie same wyniki

# 3. Compare their performance.
@time d1(1.5,2,3,4)
# 0.000016 seconds (92 allocations: 6.826 KiB)
@time d2(1.5,2,3,4)
# 0.065430 seconds (29.90 k allocations: 1.591 MiB)
@time d3(1.5,2,3,4)
# 0.013082 seconds (2.85 k allocations: 149.479 KiB)
@time d4(1.5,2,3,4)
# 0.016637 seconds (2.22 k allocations: 123.490 KiB)

# Jak widac, najwiecej pamieci alokuje funkcja d2. Jesli chodzi o czas wykonania, to pierwsza
# funkcja jest najszybsza

# 4. Generalize the code to any dimension
function d2(x1, y1, x2, y2)
    minimum((x1-x2+u1)^2+(y1-y2+u2)^2 for u1 in -1:1, u2 in -1:1)
end
