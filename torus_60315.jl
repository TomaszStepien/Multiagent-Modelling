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

# Jak widac, jesli wspolrzedne punktu sa liczbami calkowitymi,
# funkcje d1, d2, d3 zwracaja wynik, ktory jest liczba calowita (intiger), 
# natomiast funkcja d4 zwraca liczby z czescia po przecinkku (float),
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
# 0.000013 seconds (12 allocations: 560 bytes)
@time d2(1.5,2,3,4)
# 0.211002 seconds (22.68 k allocations: 1.139 MiB)
@time d3(1.5,2,3,4)
# 0.013082 seconds (2.85 k allocations: 149.479 KiB)
@time d4(1.5,2,3,4)
# 0.016637 seconds (2.22 k allocations: 123.490 KiB)

# Jak widac, najwiecej pamieci alokuje funkcja d2. Jesli chodzi o czas wykonania, to pierwsza
# funkcja jest najszybsza

# 4. Generalize the code to any dimension

function d5(tuple1::Tuple,tuple2::Tuple)
  # funkcja d5 przyjmuje 2 argumenty
  # tuple1 : krotka z wspolrzednymi pierwszego punktu w dowolnym wymiarze
  # tuple2 : krotka z wspolrzednymi drugiego punktu w dowolnym wymiarze
    if length(tuple1) != length(tuple2)
      return "Error: Dimension mismatch!"
    end
    n = length(tuple1)
    dn_all = zeros(n)
    for i = 1:n
      dn = tuple1[i] - tuple2[i]
      if dn> 0.5
          dn = 1.0 - dn
      elseif dn < -0.5
          dn= 1.0 + dn
      end
    push!(dn_all,dn*dn)
    end
    return sum(dn_all)
end

# testy
d4(0.1,0.2,0.5,0.6) #18.0
d5((1,2),(5,6)) #18.0
d5((1,4),(5,6,7)) # "Error: Dimension mismatch!"
d5((1,3,4),(5,6,7)) #17.0

@time d5((1,2),(5,6))
# 0.000022 seconds (17 allocations: 512 bytes)
