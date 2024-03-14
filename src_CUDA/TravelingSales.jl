using Random

const dimension = 10
const agentCount = 10
const adjacencyMatrix = rand(Int, dimension, dimension)

# generate initial positions
positionVector = randperm.(fill(dimension, agentCount)) # |> cu
# generate initial velocities
velocityVector = rand(1:dimension, agentCount) # |> cu

# define how to get tour distance

# get sequence of index pairs
indexPairIterator = zip(position[1:end-1], position[2:end])
# get sequence of edge weights
# view into adjacencyMatrix with indexPairVector
# sum edge weights in parallel

