workspace()

using PyPlot

include("virus_def.jl")

# simulations
dim = 100
max_iter = 100
n_agents = (dim^2)/4
pct_sick = 0.1
vaccine_power = 0.3
mutation_chance = 0.05
vaccine_desire = 0.1
default_duration = 20

go(dim = dim,
   max_iter = max_iter,
   n_agents = n_agents,
   pct_sick = pct_sick,
   vaccine_power = vaccine_power,
   mutation_chance = mutation_chance,
   vaccine_desire = vaccine_desire,
   default_duration = default_duration)


# vaccine_power
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = parameter_values[i],
                       mutation_chance = mutation_chance,
                       vaccine_desire = vaccine_desire,
                       default_duration = default_duration)/(n_agents*(1-pct_sick))
end

ioff()
plot(parameter_values, results)
title("wplyw parametru vaccine_power na procent zarazonych ludzi")
xlabel("vaccine_power")
ylabel("pct_infected")
savefig("sensitivity\\vaccine_power.png")

# vaccine_power_smoothed
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = mean(go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = parameter_values[i],
                       mutation_chance = mutation_chance,
                       vaccine_desire = vaccine_desire,
                       default_duration = default_duration)/(n_agents*(1-pct_sick)) for M in 1:50)
end

ioff()
plot(parameter_values, results)
title("wplyw parametru vaccine_power na procent zarazonych ludzi")
xlabel("vaccine_power")
ylabel("pct_infected")
savefig("sensitivity\\vaccine_power_smoothed.png")


# vaccine_desire
close()
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = vaccine_power,
                       mutation_chance = mutation_chance,
                       vaccine_desire = parameter_values[i],
                       default_duration = default_duration)/(n_agents*(1-pct_sick))
end

ioff()
plot(parameter_values, results)
title("wplyw parametru vaccine_desire na procent zarazonych ludzi")
xlabel("vaccine_desire")
ylabel("pct_infected")
savefig("sensitivity\\vaccine_desire.png")

# vaccine_desire smoothed
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = mean(go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = vaccine_power,
                       mutation_chance = mutation_chance,
                       vaccine_desire = parameter_values[i],
                       default_duration = default_duration)/(n_agents*(1-pct_sick)) for M in 1:50)
end

ioff()
plot(parameter_values, results)
title("wplyw parametru vaccine_desire na procent zarazonych ludzi")
xlabel("vaccine_desire")
ylabel("pct_infected")
savefig("sensitivity\\vaccine_desire_smoothed.png")


# mutation_chance
close()
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = vaccine_power,
                       mutation_chance = parameter_values[i],
                       vaccine_desire = vaccine_desire,
                       default_duration = default_duration)/(n_agents*(1-pct_sick))
end

ioff()
plot(parameter_values, results)
title("wplyw parametru mutation_chance na procent zarazonych ludzi")
xlabel("mutation_chance")
ylabel("pct_infected")
savefig("sensitivity\\mutation_chance.png")

# mutation_chance smoothed
parameter_values = linspace(0.0,1.0, 101)
results = zeros(length(parameter_values))
for i = 1:length(parameter_values)
    results[i] = mean(go2(dim = dim,
                       max_iter = max_iter,
                       n_agents = n_agents,
                       pct_sick = pct_sick,
                       vaccine_power = vaccine_power,
                       mutation_chance = parameter_values[i],
                       vaccine_desire = vaccine_desire,
                       default_duration = default_duration)/(n_agents*(1-pct_sick)) for M in 1:50)
end

ioff()
plot(parameter_values, results)
title("wplyw parametru mutation_chance na procent zarazonych ludzi")
xlabel("mutation_chance")
ylabel("pct_infected")
savefig("sensitivity\\mutation_chance_smoothed.png")

# wykresy 3d ==================================================================
p = linspace(0.0,1.0, 101)
r1 = zeros(length(p),length(p))
for i in 1:length(p), j in 1:length(p)
    r1[i,j] = rand(Float64)
end
close()
ioff()
fig = figure("pyplot_surfaceplot",figsize=(10,10))
ax = fig[:add_subplot](2,1,1, projection = "3d")
ax[:plot_surface](reverse(p), reverse(p), r1, rstride=2,edgecolors="k", cstride=2, cmap=ColorMap("gray"), alpha=0.8, linewidth=0.25)
xlabel("X")
ylabel("Y")
savefig("sensitivity\\desire_power.png")
