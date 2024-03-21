using Random: randperm
using CUDA
using BenchmarkTools

const dimension = 10^4
const agentCount = 10
const adjacencyMatrix = CUDA.rand(dimension, dimension)
println("summary: ", summary(adjacencyMatrix), " size: ", CUDA.sizeof(adjacencyMatrix) / 10^6)
const maxDistance = dimension - 1
const G = 0.5

# generate initial positions
positionMatrix = randperm.(fill(UInt16(dimension), agentCount)) |> stack |> cu
println("summary: ", summary(positionMatrix), " size: ", CUDA.sizeof(positionMatrix) / 10^6)
# generate initial velocities
# velocityVector = rand(1:dimension, agentCount) #|> cu

# define how to get tour distance
"""
    fitness(adjacencyMatrix :: Matrix{T}, position :: Vector) :: T where T <: Real

Get the fitness of a given tour for a given adjacencyMatrix.
"""
function fitness(adjacencyMatrix :: Union{Matrix{T}, CuArray}, position :: Union{Vector, CuArray}) #= :: T =# where T <: Real
    head = view(position, 1:length(position)-1)
    tail = view(position, 2:length(position))
    idx  = CartesianIndex.(head, tail)
    return sum(view(adjacencyMatrix, idx))
end

function fitness(adjacencyMatrix :: Union{Matrix, CuArray})
    return position -> fitness(adjacencyMatrix, position)
end

display(@btime fitness(adjacencyMatrix, view(positionMatrix, 1)))

# fitnessVector = fitness(adjacencyMatrix).(positionMatrix) #|> cu
# # set masses
# best       = minimum(fitnessVector)
# worst      = maximum(fitnessVector)
# massVector = (fitnessVector .- worst) / (best - worst) #|> cu
# totalMass  = sum(massVector)
# massVector ./= totalMass

# # search space
# hammingDistance(x :: Vector, y :: Vector) = sum(x .!= y)
# distance(x :: Vector, y :: Vector) = max(0, hammingDistance(x, y) - 1) # seems close enough

# # physics
# distanceMatrix           = (tpl -> distance(tpl...)).(Iterators.product(positionMatrix, positionMatrix))
# normalizedDistanceMatrix = 0.5 .+ distanceMatrix / (2 * maxDistance)
# accelerationMatrix       = ceil.(Int, rand(agentCount, agentCount) .* G .* stack(fill(massVector, agentCount)) .* distanceMatrix ./ normalizedDistanceMatrix)
