# define our agent
mutable struct Agent{L<:Integer,
                     S<:Integer,
                     I<:Float64,
                     V<:Bool,
                     G<:Integer,
                     D<:Integer,
                     W<:Bool,
                     X<:Integer}
    location::Tuple{L,L} # x, y coordinates
    sick::S              # 1 if healthy, 2 if sick
    immunity::I          # float in range (0,1), higher means better
    vaccinated::V        # if true, increases immunity and lowers duration
    generation::G        # generation of the virus, increased by mutation
    days_sick::D         # keeps track of sick days
    was_sick::W          # if true, cannot catch virus again
    duration::X          # days it takes to recover
end

# define how agents move
function move(agent, map)
    x, y = agent.location
    dim = size(map)[1]
    dx = rand(-1:1)
    dy = rand(-1:1)
    while dx == 0 && dy == 0
        dx = rand(-1:1)
        dy = rand(-1:1)
    end
    if dim >= (x + dx) > 0 && dim >= (y + dy) > 0 && map[x + dx, y + dy] == 0
        map[x, y] = 0
        map[x + dx, y + dy] = agent.sick
        agent.location = (x + dx, y + dy)
    end
end

# define how infected people in the neighbourhood are counted
function count_sick(agent, map)
    dim = size(map)[1]
    sick_neighbours = 0
    x,y = agent.location
    for dx in -1:1, dy in -1:1
        0 < x + dx <= dim &&
         0 < y + dy <= dim &&
         map[x + dx, y + dy] == 2 &&
          (sick_neighbours += 1)
    end

    return sick_neighbours
end

# define how agents become infected
function get_sick(agent, map)
    if agent.sick == 1 && !agent.was_sick
        sick_neighbours = count_sick(agent, map)
        virus_caught = (sick_neighbours/8)*(1 - agent.immunity)*(1 - agent.vaccinated*0.3*(1/agent.generation)) > rand(Float64)
        if virus_caught
            agent.sick = 2
            map[agent.location[1], agent.location[2]] = 2
            rand(Float64) > 0.95 && (agent.generation += 1)
            return true
        end
    end
    return false
end

# define how agents become healthy again
function get_well(agent, map)
    if agent.sick == 2
        if agent.days_sick >= agent.duration
            agent.sick = 1
            agent.was_sick = true
            map[agent.location[1], agent.location[2]] = 1
        end
        agent.days_sick += 1
    end
end

# if agent.vaccinated
#     days_to_suffer = 7 + floor(3*agent.immunity)
# else
#     days_to_suffer = 20 + floor(5*agent.immunity)
# end

# define
function go(;dim = 20, max_iter = 75, n_agents = 100, pct_sick = 0.1)
    # create map and list of agents
    map = zeros(dim, dim)
    loc_x = 1:dim
    loc_y = 1:dim
    agents = Any[]
    n_healthy = floor(n_agents*(1-pct_sick))
    n_sick = ceil(n_agents*pct_sick)

    # spawn agents
    for n in 1:n_healthy
        x = rand(loc_x)
        y = rand(loc_y)
        while map[x, y] != 0
            x = rand(loc_x)
            y = rand(loc_y)
        end
        # AGENT IS BORN HERE - HEALTHY
        location = (x,y)
        sick = 1
        immunity = 0.3
        vaccine = false
        generation = 1
        days_sick = 0
        was_sick = false
        disease_duration = 20

        agent = Agent(location,
                      sick,
                      immunity,
                      vaccine,
                      generation,
                      days_sick,
                      was_sick,
                      disease_duration)
        agents = vcat(agents,agent)
        map[x,y] = agent.sick
    end
    for n in 1:n_sick
        x = rand(loc_x)
        y = rand(loc_y)
        while map[x, y] != 0
            x = rand(loc_x)
            y = rand(loc_y)
        end
        # AGENT IS BORN HERE - SICK
        location = (x,y)
        sick = 2
        immunity = 0.3
        vaccine = false
        generation = 1
        days_sick = 0
        was_sick = false
        disease_duration = 20

        agent = Agent(location,
                      sick,
                      immunity,
                      vaccine,
                      generation,
                      days_sick,
                      was_sick,
                      disease_duration)
        agents = vcat(agents,agent)
        map[x,y] = agent.sick
    end

    # move agents
    iteration = 1
    infected = 0 # keep track of people who got sick during simulation
    while iteration <= max_iter
        for agent in shuffle!(agents)
            agent.sick == 1 &&  get_sick(agent, map) && (infected += 1)
            agent.sick == 2 && get_well(agent, map)
            move(agent, map)
        end

        # save a plot of the map
        ioff()
        fig = figure()
        imshow(map)
        savefig("plots\\$(iteration).png")
        close(fig)

        println(iteration,'\t' ,infected)
        iteration += 1
    end
    return infected
end
