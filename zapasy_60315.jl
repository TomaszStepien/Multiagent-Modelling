using Distributions

pd = Poisson(20)
rand(pd)

function simulateOneRun(m,s,S)
  pd = Poisson(20)
  h,c = 0.1, 2.0 # storage cost & sale price
  p = 0.50 # probability od delivery
  K, k = 40.0, 1.0 # fixed and variable order cost
  Xj, Yj = S, 0.0 # Stock in the morning and in the evening
  profit = 0.0 # Cumulated profit
  for j in 1:m
    Yj = Xj - rand(pd) # Substract demand for the day
    Yj < 0.0 && (Yj = 0.0) # Lost demand
    profit += c * (Xj - Yj) - h * Yj
    if Yj < s && rand()<p # We have a successful order
      profit -= K + k * (S - Yj); Xj = S
    else
      Xj = Yj
    end
  end
  profit /m
end

function simulateMultipleRun(n,m,s,S)
  mean_result = 0
  sum_result = 0
  for i = 1:n
    result = simulateOneRun(m,s,S)
    if result >= 0
      sum_result += result
    end
  end
  mean_result = sum_result/n
  return mean_result
end

simulateMultipleRun(100_000,10,120,500)

max_result = 0
for S in 150:10:250
  for s in 0:30
    result = simulateMultipleRun(100_000,10,s,S)
      if result > max_result
        println("S: ", S, " s: " , s, " result: " , round(result,2))
        max_result = result
      end
  end
end
