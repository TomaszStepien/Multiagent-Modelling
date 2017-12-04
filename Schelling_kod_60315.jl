workspace()
using PyPlot

mutable struct Agent{TI<:Integer, TF<:Integer}
    kind::TI
    location::Tuple{TF,TF}
end

x,y = Agent.location

function is_happy(agent,field, dim)
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
agents = Any[]
print(agents)

for i in 1:2
  println(i)
end

round(0.4)
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
    #img = imshow(field)
    k = 0
    while true
        no_one_moved = true
        for agent in shuffle!(agents)
            old_location = agent.location
            if is_happy(agent,field, dim) <= similar_wanted
                move(agent,field,loc)
            end
            if old_location != agent.location
                no_one_moved = false
            end
        end
        # img[:set_data](field)
        # title("Step $k")
        # show()
        sleep(delay) #(seconds) Block the current task for a specified number of seconds.
        k += 1
        (k == max_iter || no_one_moved) && break
    end
    return mean(is_happy(agent,field,dim) for agent in agents)
end

DIM = 10
CLASSES = 2
MAX_ITER = 200

srand(3)
go(DIM,CLASSES,0.1,0.9,MAX_ITER)

srand(40)
similar_wanted = 0.05:0.05:1
for similar_wanted in 0.05:0.05:1
  #for density in 0.2:0.05:0.8

      pct_similar[similar_wanted] = go(DIM,CLASSES,similar_wanted,0.9,MAX_ITER)
    #end
end

for density in 0.1:0.05:0.9
  println("density ", density, ", pct_similar ", go(DIM,CLASSES,0.8,density,MAX_ITER))
end
