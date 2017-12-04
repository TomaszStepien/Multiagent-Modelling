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

# kod pozwalajacy na porownanie rozwiazania otrzymanego za pomoca metody maxi - min
# i rozwiazania optymalnego
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
salvage = 1
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

# 2) Zaimplementować przedstawione na zajęciach rozwiązanie mini – max (Scarf 1958)

# rozwiazanie analityczne mozna wyznaczyc wykorzystujac wzory podane w
#  artykule na stronie 9
function scarf_maximin_salvage(price::Real,cost::Real, salvage::Real,dist::Distributions.Any)
    cond = (cost-salvage)/(price-salvage) * (1 + var(dist)/mean(dist)^2)
    if cond > 1
        return 0
    else
        return mean(dist) + std(dist)*f((cost-salvage)/(price-salvage))
    end
end

# kod pozwalajacy na porownanie rozwiazania otrzymanego za pomoca metody maxi - min
# i rozwiazania optymalnego
x = linspace(0.01,0.99,99)
y = zeros(length(x))
z = zeros(length(x))
for i = 1:length(x)
    cost = (1-x[i])*price
    salvage = (1-x[i])*cost
    y[i] = mean(profits_salvage(price,cost,dist,optimal_quantity_salvage(price,cost,salvage,dist),salvage,100000))
    z[i] = mean(profits_salvage(price,cost,dist,scarf_maximin_salvage(price,cost,salvage,dist),salvage,100000))
end

# 3) Zaimplementować kod, który wyznacza rozwiązanie problemu gazeciarza oparte
# na kryterium Savage’a (Perakis i Roels 2008)

# istnieje wiele metod uzyskania rozwiazania analitycznego
#  problemu w zaleznosci od znanych parametrow rozkladu

# zdefiniujmy funkcje wyznaczajace optymalna wielkosc zamowienia dla kazdego
# przypadku omawianego w artykule
function optimal_quantity_savage_range(price::Real,
                                       cost::Real,
                                       salvage::Real,
                                       UPPER::Real,
                                       LOWER::Real)
    β = (cost - salvage)/(price - salvage)
    return β*LOWER + (1-β)*UPPER
end

function optimal_quantity_savage_mean(price::Real,
                                      cost::Real,
                                      salvage::Real,
                                      MEAN::Real)
    β = (cost - salvage)/(price - salvage)
    if β >= 0.5
        return MEAN/(4*β)
    else
        return MEAN*(1-β)
    end
end

function optimal_quantity_savage_mean_median(price::Real,
                                             cost::Real,
                                             salvage::Real,
                                             MEAN::Real,
                                             MEDIAN::Real)
    β = (cost - salvage)/(price - salvage)
    if MEAN == MEDIAN
        if β >= 0.25
            return 2 * (1 - β) * MEAN
        else
            return MEAN + (MEAN/(8*β))
        end
    else
        if β >= 0.5
            if MEAN >= MEDIAN
                2*MEDIAN*(1-β)
            elseif β >= 0.75
                2*(1-β)*(2*MEAN-MEDIAN)
            elseif β >= 0.25 + (MEAN/(2*MEDIAN))
                return (2*MEAN-MEDIAN)/(4*(2*β-1))
            else
                return (2*MEDIAN)*((MEAN - β*MEDIAN)/(2*MEAN - MEDIAN))
            end
        else
            if β >= 0.25
                return 2*MEAN + 2*B*(MEDIAN - 2*MEAN)
            else
                return MEDIAN + (2*MEAN-MEDIAN)/(8*β)
            end
        end
    end
end

function optimal_quantity_savage_mean_symmetry(price::Real,
                                               cost::Real,
                                               salvage::Real,
                                               MEAN::Real)
    β = (cost - salvage)/(price - salvage)
    return 2 * MEAN * (1 - β)

end

function optimal_quantity_savage_unimodality_mode_range(price::Real,
                                                        cost::Real,
                                                        salvage::Real,
                                                        MODE::Real,
                                                        UPPER::Real,
                                                        LOWER::Real)
    β = (cost - salvage)/(price - salvage)
    if MEDIAN*(1 - 2*(β)*(1-β)) >= (β^2)*LOWER + ((1-β)^2)*UPPER
        return LOWER + sqrt((MEDIAN-LOWER)*(1-β)*(UPPER*(1-β)-LOWER*(1+β)+2*β*MEDIAN))
    else
        return UPPER - sqrt(β*(UPPER - MEDIAN)(UPPER*(2 - β)-(β * LOWER)-2*MEDIAN*(1-β)))
    end
end

function optimal_quantity_savage_unimodality_mode_median(price::Real,
                                                         cost::Real,
                                                         salvage::Real,
                                                         MODE::Real,
                                                         MEDIAN::Real)
    β = (cost - salvage)/(price - salvage)
    if MODE == MEDIAN
        return 2*MODE*sqrt(β*(1-β))
    else
        if MEDIAN < MODE && 1 - (MODE/(2*MEDIAN)) <= β <= 0.5
            MEDIAN + (1 - 2*β)*sqrt(MEDIAN*(MODE - MEDIAN))
        elseif MEDIAN < MODE && β >= 0.5
            2 * MEDIAN * sqrt(β*(1-β))
        elseif MODE < MEDIAN < MODE*((8*β^2-12*β+5)/(4*(β-1)^2)) && β >= 0.5
            2*sqrt((1-β)*MODE*(2*β*MODE-β*MEDIAN + MEDIAN - MODE))
        elseif MEDIAN >= MODE*((8*β^2-12*β+5)/(4*(β-1)^2)) && β >= 0.5
            MEDIAN - sqrt((MEDIAN - MODE)*(2*β-1)(4*β*MODE-2*β*MEDIAN-4*MODE+3*MEDIAN))
        else
            return NaN
        end
    end
end

function optimal_quantity_savage_mean_unimodality_symmetry(price::Real,
                                                           cost::Real,
                                                           salvage::Real,
                                                           MEAN::Real)
    β = (cost - salvage)/(price - salvage)
    if β >= 0.5
        return 2*MEAN*sqrt(β*(1-β))
    else
        return 2*MEAN*(1-sqrt(β*(1-β)))
    end
end

function optimal_quantity_savage_mean_variance(price::Real,
                                               cost::Real,
                                               salvage::Real,
                                               MEAN::Real,
                                               VARIANCE::Real)
    β = (cost - salvage)/(price - salvage)
    if sqrt(VARIANCE)/MEAN <= sqrt(1-β)
        return maximum(0, MEAN + 0.4 * sqrt(VARIANCE)*(1 - 2*β)/sqrt(β*(1-β)))
    else
        return NaN
    end
end

#

# nastepnie zdefiniujmy funkcje matke, ktora zwroci odpowiedni wynik
function optimal_quantity_savage(price::Real,
                                 cost::Real,
                                 salvage::Real;
                                 MEAN::Real = NaN,
                                 VARIANCE::Real = NaN,
                                 MODE::Real = NaN,
                                 MEDIAN::Real = NaN,
                                 SYMMETRY::Bool = false,
                                 UNIMODALITY::Bool = false,
                                 UPPER::Real = NaN,
                                 LOWER::Real = NaN)
    if !isnan(MEAN) && !isnan(VARIANCE)
        return optimal_quantity_savage_mean_variance(price, cost, salvage, MEAN, VARIANCE)
    elseif !isnan(MEAN) && UNIMODALITY && SYMMETRY
        return optimal_quantity_savage_mean_unimodality_symmetry(price, cost, salvage, MEAN)
    elseif !isnan(MEAN) && !isnan(MEDIAN)
        return optimal_quantity_savage_mean_median(price, cost, salvage, MEAN, MEDIAN)
    elseif !isnan(MEAN) && SYMMETRY
        return optimal_quantity_savage_mean_symmetry(price, cost, salvage, MEAN)
    elseif !isnan(MEAN)
        return optimal_quantity_savage_mean(price, cost, salvage, MEAN)
    elseif UNIMODALITY && !isnan(MODE) && !isnan(MEDIAN)
        return optimal_quantity_savage_unimodality_mode_median(price, cost, salvage, MODE, MEDIAN)
    elseif UNIMODALITY && !isnan(MODE) && !isnan(UPPER) && !isnan(LOWER)
        return optimal_quantity_savage_unimodality_mode_range(price, cost, salvage, MODE, UPPER, LOWER)
    else
        return optimal_quantity_savage_range(price, cost, salvage, UPPER, LOWER)
    end
end

optimal_quantity_savage(price, cost, salvage, UPPER = 100, LOWER = 0)

# 4) Porownac oba proponowane rozwiazania, uwzgledniajac przy tym rozwiazanie
# optymalne przy znanym rozkladzie popytu
