using Distributions

function simulateOneRun(m, s, S)
    pd = Poisson(20)
    h, c = 0.1, 2.0 # storage cost & sale price
    p = 0.5 # probability of delivery
    K, k = 40.0, 1.0 # fixed and ariable order cost
    Xj, Yj = S, 0.0 # Stock in the morning and in the evening
    profit = 0.0 # cumulated profit
    for j in 1:m
        Yj = Xj - rand(pd) # subtract demand for the day
        Yj < 0 && (Yj = 0.0) # lost demant
        profit += c * (Xj - Yj) - h * Yj; Xj = S
        if Yj < s && rand()< p # we have a successful order
            profit -= K + k * (S - Yj); Xj = S
        else
            Xj = Yj
        end
    end
    profit / m
end


for S in [190, 200.0, 210.0]
    println(S, "\t", @time simulateOneRun(10_000_000, 100.0, S))
end
