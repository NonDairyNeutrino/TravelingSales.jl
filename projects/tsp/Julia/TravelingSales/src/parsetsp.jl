# functionality to parse xml formatted tsp files into adjacency matrices

"""
    parseProblem(path :: String) :: Matrix

Gives the adjacency matrix of the given TSP instance (.xml files)
"""
function parseProblem(filePath :: String) :: Matrix
    println(filePath)
    @assert splitext(filePath)[2] == ".xml" "Please give a .xml file"

    fileString = readchomp(filePath) # reads in the whole file as a string, problematic for large problems
    regex = r"<edge cost=\"(?<weight>[\d.]+e[\+\-]\d+)\">(?<node>\d+)"
    matchVector = eachmatch(regex, fileString) |> collect

    dimension = maximum(parse(Int, match["node"]) for match in matchVector) + 1

    adjacencyMatrix = zeros(dimension, dimension)
    if matchVector[1]["node"] == "0"
        row = 0
    else
        row = 1
    end
    
    for match in matchVector
        if match["node"] == "0"
            row += 1
        end
        col = parse(Int, match["node"]) + 1
        adjacencyMatrix[row, col] = parse(Float64, match["weight"])
    end
    return adjacencyMatrix
end