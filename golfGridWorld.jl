## create some gridworld

using Random


function randomPolicy(A)
    return rand(A, 1)[1]
end # randomPolicy


function createMapping(S⁺, A)
    mapping = Dict([(s, Dict([(A[1], s + 1), (A[2], s + 5), (A[3], s - 5), (A[4], s - 1)])) for s ∈ S⁺])
    for (action, edge) ∈ zip(A, [range(5, 25, 5), range(20, 25), range(1, 5), range(1, 21, 5)])
        for loc ∈ edge
            mapping[Int(loc)][action] = Int(loc)
        end
    end
    return mapping
end #createMapping


function printGrid(P, pin, crocodile)
    grid = [P[s] for s ∈ S⁺]
    grid[pin] = "⛳"
    grid[crocodile] = "🐊"

    for el in [range(1,5), range(6, 10), range(11, 15), range(16, 20), range(21, 25)]
        [print(vis[item], "\t") for item in el]
        print("\n")
    end

end #printGrid


function valueIteration(S, V, A, P, Θ, γ)

    while true
        Δ = 0.0
        V′ = deepcopy(V)

        for s in S
            v = V[s]
            V[s]= maximum([R[Mapping[s][a]] + γ * V′[Mapping[s][a]] for a ∈ A])
            P[s] = A[argmax([R[Mapping[s][a]] + γ * V′[Mapping[s][a]] for a ∈ A])]
            Δ = max(Δ, abs(v - V[s]))
        end #for
        
        Δ < Θ ? break : continue
        
    end #while
    
    return P;
    
end #valueIteration

# Set up the Gridworld

# state space
S⁺ = [s for s ∈ range(1, 25)]

# possible actions East, North, South, West
A = ["→", "↓", "↑", "←"]

# Set mapping in the space
mapping = createMapping(S⁺, A)




# Values, all zero
V = Dict([(s, 0.0) for s ∈ S⁺])

# Reward -1 for each step
R = Dict([(s, -1) for s ∈ S⁺])

# arbitrary Policy
P = Dict([(s, randomPolicy(A)) for s ∈ S⁺])




# set the locations of the pin and the crocodile
pin = 22
crocodile = 6


# Set the rewards for the pin and the crocodile
R[pin] = 9
R[crocodile] = -11


# Set the space of non terminal states
S = [s for s ∈ S⁺ if s ∉ [pin, crocodile]]


# condition to break the while loop
Θ = 0.0001
# future reward discount factor 
γ = 0.9



P = valueIteration(S, V, A, P, Θ, γ);

printGrid(P, pin, crocodile)






