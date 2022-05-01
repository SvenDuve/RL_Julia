# require a 4 x 4 gridworld

function plotGrid(grid, dim)
    return reshape(grid, dim)
end #plotGrid


function createMapping(S⁺, A)
    mapping = Dict([(s, Dict([(A[1], s + 1), (A[2], s + 4), (A[3], s - 4), (A[4], s - 1)])) for s ∈ S⁺])
    for (action, edge) ∈ zip(A, [range(4, 16, 4), range(12, 16), range(1, 4), range(1, 13, 4)])
        for loc ∈ edge
            mapping[Int(loc)][action] = Int(loc)
        end
    end
    return mapping
end #createMapping



r = -1
# state space
S = [s for s ∈ range(1, 16)]
# possible actions East, North, South, West
A = ["→", "↓", "↑", "←"]

γ = 1

mp = createMapping(S, A)

π = Dict([(s, Dict([(a, 0.25) for a ∈ A])) for s ∈ S]);

v₀ = zeros(16);

plotGrid(v₀, (4, 4))

v₁ = zeros(16);
for s ∈ S[2:15]
    v₁[s] = sum([π[s][a]*(r + γ * v₀[mp[s][a]]) for a in A]) 
end#for

plotGrid(v₁, (4, 4))

v₂ = zeros(16);
for s ∈ S[2:15]
    v₂[s] = sum([π[s][a]*(r + γ * v₁[mp[s][a]]) for a in A]) 
end#for
plotGrid(v₂, (4, 4))

v₃ = zeros(16);
for s ∈ S[2:15]
    v₃[s] = sum([π[s][a]*(r + γ * v₂[mp[s][a]]) for a in A]) 
end#for
plotGrid(v₃, (4, 4))



