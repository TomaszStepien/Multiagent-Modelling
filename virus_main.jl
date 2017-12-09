workspace()

using PyPlot

include("virus_def.jl")

# simulations
dim = 20
max_iter = 75
n_agents = 400
pct_sick = 0.1
vaccine_power = 0.3
mutation_chance = 0.05
vaccine_desire = 0.1
default_duration = 30

go(dim = dim,
   max_iter = max_iter,
   n_agents = n_agents,
   pct_sick = pct_sick,
   vaccine_power = vaccine_power,
   mutation_chance = mutation_chance,
   vaccine_desire = vaccine_desire,
   default_duration = default_duration)

