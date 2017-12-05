# rozwiazania poszczegolnych podpunktow pod kodem z zajec

using PyPlot

mutable struct Agent{TI<:Integer, TF<:Integer}
    kind::TI
    location::Tuple{TF,TF}
end

function check_similarity(agent,field, dim)
    same_color = 0
    neighbors = 0
    x,y = agent.location
    for dx in [-1, 0, 1]
        for dy in [-1, 0, 1]
            if dx != 0 || dy != 0
                r_x = mod(x + dx - 1, dim) + 1
                r_y = mod(y + dy - 1, dim) + 1
                if field[r_x,r_y] != 0
                    neighbors += 1
                    if field[r_x, r_y] == agent.kind
                        same_color += 1
                    end
                end
            end
        end
    end
    if neighbors == 0
        return 1
    else
        return  same_color / neighbors
    end
end

function move(agent,field,loc)
    x,y = agent.location
    dx,dy = rand(loc)
    while field[dx,dy] != 0
        dx,dy = rand(loc)
    end
    agent.location = (dx,dy)
    field[x,y] = 0
    field[dx,dy] = agent.kind
end

function go(dim, classes, similar_wanted, density, max_iter; delay=0.01)
    # create field, agents and place them randomly
    field = zeros(dim,dim)
    loc = Tuple{Int, Int}[(x,y) for x in 1:dim for y in 1:dim]
    agents = Any[]
    for i = 1:classes
        for j = 1:round(density*dim*dim)/classes
            dx,dy = rand(loc)
            while field[dx,dy] != 0
                dx,dy = rand(loc)
            end
            a = Agent(i,(dx,dy))
            agents = vcat(agents,a)
            field[dx,dy] = a.kind
        end
    end
    # img = imshow(field)

    # move agents
    k = 0
    while true
        no_one_moved = true
        for agent in shuffle!(agents)
            old_location = agent.location
            if check_similarity(agent,field, dim) <= similar_wanted
                move(agent,field,loc)
            end
            if old_location != agent.location
                no_one_moved = false
            end
        end
        # img[:set_data](field)
        # title("Step $k")
        # show()
        # sleep(delay)
        k += 1
        (k == max_iter || no_one_moved) && break
    end
    return mean(check_similarity(agent,field,dim) for agent in agents)
end

DIM = 10
CLASSES = 2
max_iter = 2000
similar_wanted = 0.4
density = 0.9

go(DIM,CLASSES,similar_wanted,density,max_iter)

# 1. Zbadac w jaki sposob zmiana parametrow similar_wanted i density zmienia
# koncowa wartosc parametru pct_similar

# sprawdzmy oddzielnie zmiany kazdego parametru ceteris paribus
# a. similar_wanted
parameter_values = linspace(0.01,0.99,99)
results_1 = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_1[i] = go(DIM,CLASSES, parameter_values[i], density, max_iter)
end

plot(parameter_values, results)
title("wplyw parametru similar_wanted na szczescie obywateli")
xlabel("similar_wanted")
ylabel("pct_similar")

# by zmniejszyc wahania losowe mozna kazda konfiguracje parametrow zasymulowac
# wiele razy

results_2 = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_2[i] = mean(go(DIM,CLASSES, parameter_values[i], density, max_iter) for e in 1:10)
end

plot(parameter_values, [results_1 results_2])
title("wplyw parametru similar_wanted na szczescie obywateli")
xlabel("similar_wanted")
ylabel("pct_similar")

# zgodnie z intuicja poziom segregacji osiaga duze wartosci dla wartosci
# parametru zblizonych do srodka przedzielu (0,1) i male wartosci dla wartosci
# zblizonych do krancow tego przedzialu. Silna niechec zarowno do swojego typu
# jak i innego typu powoduje ze ciezko nam znalezc miejsce w ktorym bedziemy
# zadowoleni z sasiadow

# b. density
parameter_values = linspace(0.1,0.99,90)
results_3 = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_3[i] = go(DIM,CLASSES, similar_wanted, parameter_values[i], max_iter)
end

plot(parameter_values, results_3)
title("wplyw parametru density na szczescie obywateli")
xlabel("density")
ylabel("pct_similar")

results_4 = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_4[i] = mean(go(DIM,CLASSES, similar_wanted, parameter_values[i], max_iter) for e in 1:10)
end

plot(parameter_values, [results_3 results_4])
title("wplyw parametru density na szczescie obywateli")
xlabel("density")
ylabel("pct_similar")

# im wieksza wartosc parametru density tym mniejszy poziom segregacji

# 2. Zmodyfikowac parametr similar_wanted w taki sposob aby byl heterogeniczny
# dla wszystkich agentow

mutable struct Agent_h{TI<:Integer, TF<:Integer, TG<:Real}
    kind::TI
    location::Tuple{TF,TF}
    similar_wanted::TG
end

# function check_similarity stays the same

# we can redefine similar_wanted to be a random float in range (0,1)

function go_h(dim, classes, density, max_iter; delay=0.01)
    # create field, agents and place them randomly

    field = zeros(dim,dim)
    loc = Tuple{Int, Int}[(x,y) for x in 1:dim for y in 1:dim]
    agents = Any[]
    for i = 1:classes
        for j = 1:round(density*dim*dim)/classes
            dx,dy = rand(loc)
            while field[dx,dy] != 0
                dx,dy = rand(loc)
            end
            # we have to add random similar_wanted
            similar_wanted = rand(Float64)
            a = Agent_h(i,(dx,dy), similar_wanted)
            agents = vcat(agents,a)
            field[dx,dy] = a.kind
        end
    end
    # img = imshow(field)

    # move agents
    k = 0
    while true
        no_one_moved = true
        for agent in shuffle!(agents)
            old_location = agent.location
            # we have to take each agents similar_wanted
            if check_similarity(agent,field, dim) <= agent.similar_wanted
                move(agent,field,loc)
            end
            if old_location != agent.location
                no_one_moved = false
            end
        end
        # img[:set_data](field)
        # title("Step $k")
        # show()
        # sleep(delay)
        k += 1
        (k == max_iter || no_one_moved) && break
    end
    return mean(check_similarity(agent,field,dim) for agent in agents)
end

go_h(DIM,CLASSES,density,max_iter)

# 3. Sprawdzic w jaki sposob modyfikacja z punktu 2 zmienia otrzymane wyniki

# zasymulujmy scenariusz homogeniczny i heterogeniczny 1000 razy i porownajmy otrzymany
# sredni poziom segregacji
homo_segregation = mean(go(DIM,CLASSES,similar_wanted,density,max_iter) for i in 1:1000)
hetero_segragation = mean(go_h(DIM,CLASSES,density,max_iter) for i in 1:1000)

println(homo_segregation)
println(hetero_segregation)

# dodajmy jeszcze wykres - wersja hetorgeniczna jest niezalezna od osi wartosci parametru,
# podczas gddy homogeniczna od niego zalezy

parameter_values = linspace(0.01,0.99,99)
results_homo = zeros(length(parameter_values))
results_hetero = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_homo[i] = mean(go(DIM,CLASSES, parameter_values[i], density, max_iter) for j in 1:3)
    results_hetero[i] = mean(go_h(DIM,CLASSES, density, max_iter) for j in 1:3)
end

plot(parameter_values, [results_homo results_hetero])
title("porownanie wersji homogenicznej i heterogenicznej")
xlabel("similar_wanted")
ylabel("pct_similar")
legend(["results_homo", "results_hetero"])
# tej symulacji wskaznik segregacji dla populacji homogenicznej okazal sie wyzszy

# 4. Zmienic sasiedztwo Moore'a na sasiedztwo von Neumanna
# w tym celu trzeba zmienic funkcje check_similarity
function check_similarity_neuman(agent,field, dim)
    same_color = 0
    neighbors = 0
    x,y = agent.location
    for dx in [-1, 0, 1]
        for dy in [-1, 0, 1]
            if (dx != 0 && dy == 0) || (dx == 0 && dy != 0)
                r_x = mod(x + dx - 1, dim) + 1
                r_y = mod(y + dy - 1, dim) + 1
                if field[r_x,r_y] != 0
                    neighbors += 1
                    if field[r_x, r_y] == agent.kind
                        same_color += 1
                    end
                end
            end
        end
    end
    if neighbors == 0
        return 1
    else
        return  same_color / neighbors
    end
end

function go_neuman(dim, classes, similar_wanted, density, max_iter; delay=0.01)
    # create field, agents and place them randomly
    field = zeros(dim,dim)
    loc = Tuple{Int, Int}[(x,y) for x in 1:dim for y in 1:dim]
    agents = Any[]
    for i = 1:classes
        for j = 1:round(density*dim*dim)/classes
            dx,dy = rand(loc)
            while field[dx,dy] != 0
                dx,dy = rand(loc)
            end
            a = Agent(i,(dx,dy))
            agents = vcat(agents,a)
            field[dx,dy] = a.kind
        end
    end
    # img = imshow(field)

    # move agents
    k = 0
    while true
        no_one_moved = true
        for agent in shuffle!(agents)
            old_location = agent.location
            if check_similarity_neuman(agent,field, dim) <= similar_wanted
                move(agent,field,loc)
            end
            if old_location != agent.location
                no_one_moved = false
            end
        end
        # img[:set_data](field)
        # title("Step $k")
        # show()
        # sleep(delay)
        k += 1
        (k == max_iter || no_one_moved) && break
    end
    return mean(check_similarity_neuman(agent,field,dim) for agent in agents)
end

# 5. Sprawdzic w jaki sposob modyfikacja z punktu 4 zmienia otrzymane wyniki


# zasymulujmy wersje z sasiedztwem Moora i z sasiedztwem Von Neumana 1000 razy
# i porownajmy otrzymany sredni poziom segregacji

moore_segregation = mean(go(DIM,CLASSES,similar_wanted,density,max_iter) for i in 1:1000)
neuman_segragation = mean(go_neuman(DIM,CLASSES,density,similar_wanted,max_iter) for i in 1:1000)

println(moore_segregation)
println(neuman_segragation)

# w tej symulacji wersja modelu z sasiedztwem Moora daje wyzszy
# sredni wskaznik segregacji

# dodajmy jeszcze wykres by zobaczyc jak 2 podejscia roznia sie w zaleznosci
# od parametru similar_wanted

parameter_values = linspace(0.01,0.99,99)
results_moore = zeros(length(parameter_values))
results_neuman = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results_moore[i] = mean(go(DIM,CLASSES, parameter_values[i], density, max_iter) for j in 1:3)
    results_neuman[i] = mean(go_neuman(DIM,CLASSES,parameter_values[i], density, max_iter) for j in 1:3)
end

plot(parameter_values, [results_moore results_neuman])
title("porownanie wersji Moora i Von Neumanna")
xlabel("similar_wanted")
ylabel("pct_similar")
legend(["results_moore", "results_neuman"])
