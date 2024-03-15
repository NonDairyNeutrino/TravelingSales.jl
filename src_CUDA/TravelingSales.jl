using Random: randperm

const dimension = 10
const agentCount = 10
const adjacencyMatrix = rand(1:10, dimension, dimension)

# generate initial positions
positionVector = randperm.(fill(dimension, agentCount)) # |> cu
# generate initial velocities
velocityVector = rand(1:dimension, agentCount) # |> cu

# define how to get tour distance
"""
    fitness(adjacencyMatrix :: Matrix{T}, position :: Vector) :: T where T <: Real

Get the fitness of a given tour for a given adjacencyMatrix.
"""
function fitness(adjacencyMatrix :: Matrix{T}, position :: Vector) :: T where T <: Real
    # get sequence of index pairs
    indexPairIterator = zip(position[1:end-1], position[2:end])
    # for whatever reason, `view` takes more time and memory than `getindex`
    return sum((indexPair -> adjacencyMatrix[indexPair...]).(indexPairIterator))[1]
end

function fitness(adjacencyMatrix :: Matrix)
    return position -> fitness(adjacencyMatrix, position)
end

fitnessVector = fitness(adjacencyMatrix).(positionVector)
# set MASSES
best       = minimum(fitnessVector)
worst      = maximum(fitnessVector)
massVector = (fitnessVector .- worst) / (best - worst)
totalMass  = sum(massVector)
massVector ./= totalMass

