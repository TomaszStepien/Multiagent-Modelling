
using PyPlot
# using Distributions

# workspace()

# define our agent
mutable struct Agent{L<:Integer, S<:Integer} # , I<:Float64
    location::Tuple{L,L}
    sick::S
    # immunity::I
end

# define how agents move
function move(agent, map)
    x, y = agent.location
    dim = size(map)[1]
    for dx in rand([-1,1]), dy in rand([-1,1])
        if dim >= (x + dx) > 0 && dim >= (y + dy) > 0 && map[x + dx, y + dy] == 0
            map[x, y] = 0
            map[x + dx, y + dy] = agent.sick
            agent.location = (x + dx, y + dy)
        end
    end
end

# define how we count sick people in the neighbourhood
function count_sick(agent, map)
    dim = size(map)[1]
    sick_neighbours = 0
    x,y = agent.location
    if x == 1 && y == 1 # corner
        for dx in 1, dy in 1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif x == 1 && y == dim # corner
        for dx in 1, dy in -1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif x == dim && y == 1 # corner
        for dx in -1, dy in 1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif x == dim && y == dim # corner
        for dx in -1, dy in -1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif x == dim # side
        for dx in -1, dy in -1:2:1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif x == 1 # side
        for dx in 1, dy in -1:2:1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif y == dim # side
        for dx in -1:2:1, dy in -1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    elseif y == 1 # side
        for dx in -1:2:1, dy in 1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    else # interior
        for dx in -1:2:1, dy in -1:2:1
            map[x + dx, y + dy] == 2 && (sick_neighbours += 1)
        end
    end
    return sick_neighbours
end

# define how agents become sick
function get_sick(agent, map)
    dim = size(map)[1]
    sick_neighbours = count_sick(agent, map)
    if agent.sick == 1 && sick_neighbours >= 1
        agent.sick = 2
        map[agent.location[1], agent.location[2]] = 2
        return true
    end
    return false
end


function go(;dim = 15, max_iter = 75, n_agents = 20, delay = 0.01)
    # create map and agents list
    map = zeros(dim, dim)
    loc_x = collect(1:dim)
    loc_y = collect(1:dim)
    agents = Any[]
    # spawn agents
    for n in 1:n_agents
        x = rand(loc_x)
        y = rand(loc_y)
        while map[x, y] != 0
            x = rand(loc_x)
            y = rand(loc_y)
        end
        agent = Agent((x,y), rand([1,2]))
        agents = vcat(agents,agent)
        map[x,y] = agent.sick
    end
    # img = imshow(map)

    # move agents
    iteration = 1
    infected = 0 # keeps track of people who got sick during simulation
    while iteration <= max_iter
        for agent in shuffle!(agents)
            old_location = agent.location
            get_sick(agent, map) && (infected += 1)
            move(agent, map)
        end
        println(iteration,'\t' ,infected)
        # save a plot of the map
        ioff()
        fig = figure()
        imshow(map)
        savefig("plots\\$(iteration).png")
        close(fig)
        iteration += 1
    end
    return infected
end

go()
