using Distributions


function simulateOneRun(m::Int64, s::Int64, S::Int64)
    # simulates m days and returns average daily profit
    pd = Poisson(20)
    h, c = 0.1, 2.0 # storage cost & sale price
    p = 0.5 # probability of delivery
    K, k = 40.0, 1.0 # fixed and variable order cost
    Xj, Yj = S, 0.0 # Stock in the morning and in the evening
    profit = 0.0 # cumulated profit
    for j in 1:m
        Yj = Xj - rand(pd) # subtract demand for the day
        Yj < 0 && (Yj = 0.0) # lost demant
        profit += c * (Xj - Yj) - h * Yj
        if Yj < s && rand()< p # we have a successful order
            profit -= K + k * (S - Yj); Xj = S
        else
            Xj = Yj
        end
    end
    profit / m
end

# let's define a helping function which will run a simulation multiple times
function simulate(n::Int64, m::Int64, s::Int64, S::Int64)
    total_profit = 0
    for i in 1:n
        total_profit += simulateOneRun(m, s, S)
    end
    return total_profit/n
end

# now we can optimize parameters S and s
# first lets define the search range
S_range = 100:1:300
s_range = 0:1:100

# let's define number of days and number of simulations
simulations = 1000
days = 100
# that means we will simulate a 100 days scenario 1000 times

# now let's simulate
best_v = 0.0
for S in S_range
    for s in s_range
        v = simulate(simulations, days, s, S)
        if v > best_v
            println("S: ", S, "\t", "s: ", s, "\t", "avg_daily_profit: ", v)
            best_v = v
        end
    end
end
