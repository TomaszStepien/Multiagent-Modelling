# rozwiazanie pracy domowej pod kodem z zajec

using Distributions

price = 4.5
cost = 2.5
dist = Exponential(200.0)

# kod funkcji, ktora wylicza wartosc zysku gazeciarza dla zadanego zamowienia
profits(price::Real,
        cost::Real,
        dist::Distributions.Any,
        quantity::Real,
        iter::Int64) = [price*min(quantity,rand(dist)) - cost*quantity for i = 1:iter]

function profits(price::Real,
                 cost::Real,
                 dist::Distributions.Any,
                 quantity::Real,
                 iter::Int64)
    [price*min(quantity,rand(dist)) - cost*quantity for i = 1:iter]
end

# funkcja, ktora dla zadanego rozkladu, ceny zakupu i ceny sprzedazy wyznacza
# optymalna wielkosc zamowienia
function optimal_quantity(price::Real,
                          cost::Real,
                          dist::Distributions.Any)
    quantile(dist,(price - cost)/price)
end
# kod, ktory oblicza zysk dla roznych zamowionych ilosci dobr
x = linspace(10.0,300.0,291)
y = zeros(length(x))
for i = 1:length(x)
    y[i] = mean(profits(price,cost,dist,x[i],100000))
    println(y[i])
end

# znajdzmy optymalna wielkosc zamowienia zarowno symulacyjnie jak i analitycznie
optimal_simulation = x[find(y .== maximum(y))]
println(optimal_simulation)
optimal_analitic = optimal_quantity(price,cost,dist)
println(optimal_analitic)

# i wyliczmy maksymalny zysk jaki moze osiagnac gazeciarz
max_profit = mean(profits(price,cost,dist,optimal_analitic,10000000))
println(max_profit)
###############################################################################
# co jednak gdy nie znamy rozkladu z ktorego losowany jest popyt?
# Wtedy do wyznaczenia optymalnej wielkosci zamowionych produktow
# mozemy uzyc danych historycznych (zob. Levi et al.
# "Provably Near-Optimal Sampling-Based Policies for Stochastic Inventory Control Models")
# korzystamy wtedy z podejscia znanego jako  sample average approximation
# i traktujemy dane historyczne jako empiryczna dystrybuante popytu
# na ich podstawie wyznaczamy optymalna wielkosc zamowienia w sposob identyczny jak poprzednio
function saa_profits(price::Real,cost::Real,dist::Distributions.Any,n::Int64, iter::Int64)
    samples = rand(dist,n)
    optimal_quantity = quantile(samples,(price - cost)/price)
    return mean(profits(price,cost,dist,optimal_quantity,iter))
end

# kod, ktory pozwala wyznaczyc symulacyjnie najmniejsza ilosc historycznych
# wartosci popytu potrzebnych do wyznaczenia optymalnej wielkosci zamowienia
x = linspace(1.0,200.0,200)
y = zeros(length(x))
for i = 1:length(x)
    y[i] =  saa_profits(price,cost,dist,Int(x[i]), 100000) - max_profit
end

optimal_N = x[findfirst(abs.(y) .< 0.01)]

###############################################################################
# rozpatrzmy problem gdy rozklad nie jest dany, ale znamy jego srednia i wariancje.
# Wtedy mozna zastosowan podejscie maxi - min zaproponowane przez Scarfa
# w "A min-max solution to an inventory problem". Polega ono na maksymalizacji
# zysku w najgorszym mozliwym scenariuszu
# zdefiniujmy funkcje pomocnicza
function f(a)
    return 0.5 * ((1 - 2*a)/sqrt(a*(1-a)))
end

#i funkcje wyznaczajaca optymalna decyzje zgodnie z podejsciem maxi - min
function scarf_maximin(price::Real,cost::Real,dist::Distributions.Any)
    cond = cost/price * (1 + var(dist)/mean(dist)^2)
    if cond > 1
        return 0
    else
        return mean(dist) + std(dist)*f(cost/price)
    end
end

#kod pozwalajacy na porownanie rozwiazania otrzymanego za pomoca metody maxi - min i rozwiazania optymalnego
x = linspace(0.01,0.99,99)
y = zeros(length(x))
z = zeros(length(x))
for i = 1:length(x)
    y[i] = mean(profits(price,(1 - x[i])*price,dist,optimal_quantity(price,(1 - x[i])*price,dist),100000))
    z[i] = mean(profits(price,(1 - x[i])*price,dist,scarf_maximin(price,(1 - x[i])*price,dist),100000))
end
################################################################################


# homework
# kod funkcji, ktora wylicza wartosc zysku gazeciarza dla zadanego zamowienia
# z uwzględnieniem tzw. salvage value czyli wartosci odzyskiwanej z niesprzedanego towaru
function profits_salvage(price::Real,
                         cost::Real,
                         dist::Distributions.Any,
                         quantity::Real,
                         salvage::Real,
                         iter::Int64)
    x = zeros(0)
    for i = 1:iter
        D = rand(dist)
        append!(x, price*min(quantity, D) - cost*quantity + salvage*max(0, quantity - D)) 
    end

    x
end
# 1) Wyznaczyć optymalną wielkość zamówienia w przypadku gdy rozkład popytu jest znany

# zeby znalezc rozwiazanie analityczne nalezy zastosowac wzor uwzgledniajacy salvage value
# An Application of the Two-Period Newsvendor Problem - p. 8
optimal_quantity_salvage(price::Real,
                         cost::Real,
                         salvage::Real,
                         dist::Distributions.Any) = quantile(dist,(price - cost)/(price - salvage))

# kod, ktory oblicza zysk dla roznych zamowionych ilosci dobr
x = linspace(10.0,300.0,291)
y = zeros(length(x))
salvage = 0.5
for i = 1:length(x)
    y[i] = mean(profits_salvage(price,cost,dist,x[i], salvage, 100000))
    println(y[i])
end

# znajdzmy optymalna wielkosc zamowienia zarowno symulacyjnie jak i analitycznie
optimal_simulation = x[find(y .== maximum(y))]
println(optimal_simulation)
optimal_analitic = optimal_quantity_salvage(price,cost,salvage,dist)
println(optimal_analitic)

max_profit = mean(profits(price,cost,dist,optimal_analitic,10000000))
println(max_profit)
