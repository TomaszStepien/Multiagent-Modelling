workspace()
using Distributions
using PyPlot

price = 4.5
cost = 2.5
salvage = 0.5
# dowolne wartosci spelniajace warunek price > cost > salvage

dist = Exponential(200.0)

```
Wyznaczyć optymalną wielkość zamówienia w przypadku gdy rozkład popytu jest znany
```

# kod funkcji, ktora wylicza wartosc zysku gazeciarza dla zadanego zamowienia
function profits(price::Real,cost::Real,salvage::Real,dist::Distributions.Any,quantity::Real,iter::Int64)
  x = Float64[]
  for i = 1:iter
    demand = rand(dist)
    push!(x,price*min(quantity,demand) - cost*quantity + salvage*max(0,quantity - demand))
  end
  return x
end

#funkcja, ktora dla zadanego rozkladu, ceny zakupu, ceny zwrotu i ceny sprzedazy wyznacza optymalna wielkosc zamowienia
# wzor pochodzi z artykulu evah15_public, strona 5
optimal_quantity(price::Real,cost::Real,salvage::Real,dist::Distributions.Any) = quantile(dist,(price - cost)/(price - salvage))

#kod, ktory oblicza zysk dla roznych zamowionych ilosci dobr
srand(1)
x = linspace(10.0,300.0,291)
y = zeros(length(x))
for i = 1:length(x)
    y[i] = mean(profits(price,cost,salvage,dist,x[i],1000000))
end

plot(x,y)

#znajdzmy optymalna wielkosc zamowienia zarowno symulacyjnie jak i analitycznie
optimal_simulation = x[find(y .== maximum(y))]
print(optimal_simulation)
optimal_analitic = optimal_quantity(price,cost,salvage,dist)
print(round(optimal_analitic))
# i wyliczmy maksymalny zysk jaki moze osiagnac gazeciarz
max_profit = mean(profits(price,cost,salvage,dist,optimal_analitic,10000000))

######################################################################################################
'''
Zaimplementować przedstawione na zajęciach rozwiązanie mini – max (Scarf 1958)
'''
#zdefiniujmy funkcje pomocnicza
function f(a)
    return 0.5 * ((1 - 2*a)/sqrt(a*(1-a)))
end

#i funkcje wyznaczajaca optymalna decyzje zgodnie z podejsciem maxi - min
function scarf_maximin(price::Real,cost::Real,salvage::Real,dist::Distributions.Any)
    cond = (cost-salvage)/(price-salvage) * (1 + var(dist)/mean(dist)^2)
    if cond > 1
        return 0
    else
        return mean(dist) + std(dist)*f((cost-salvage)/(price-salvage))
    end
end

#kod pozwalajacy na porownanie rozwiazania otrzymanego za pomoca metody maxi - min i rozwiazania optymalnego
x = linspace(0.01,0.99,99)
y = zeros(length(x))
z = zeros(length(x))
for i = 1:length(x)
    y[i] = mean(profits(price,cost,salvage,dist,optimal_quantity(price,cost,salvage,dist),100000))
    z[i] = mean(profits(price,cost,salvage,dist,scarf_maximin(price,cost,salvage,dist),100000))
end
plot(x,[y z])
######################################################################################################
'''
Zaimplementować kod, który wyznacza rozwiązanie problemu gazeciarza oparte na kryterium Savage’a (Perakis i Roels 2008)
'''
function savage(price::Real,cost::Real,salvage::Real,dist::Distributions.Any)
    β = (cost - salvage)/(price - salvage) # dla goodwill loss = 0
    if β <= 0.5
      optimal_quantity = mean(dist)*(1-β)
    else
      optimal_quantity = mean(dist)/4*β
    end
    return optimal_quantity
end

'''
Porównać oba proponowane rozwiązania, uwzględniając przy tym rozwiązanie optymalne przy znanym rozkładzie popytu
'''
x = linspace(0.01,0.99,99)
m = zeros(length(x))
y = zeros(length(x))
z = zeros(length(x))
for i = 1:length(x)
    cost = (1 - x[i])*price
    salvage =  (1 - x[i])*cost
    m[i] = mean(profits(price,cost,salvage,dist,optimal_quantity(price,cost,salvage,dist),100000))
    y[i] = mean(profits(price,cost,salvage,dist,scarf_maximin(price,cost,salvage,dist),100000))
    z[i] = mean(profits(price,cost,salvage,dist,savage(price,cost,salvage,dist),100000))
end
plot(x,[m y z])
