using LinearAlgebra, SparseArrays
using CUDA

function basisVector(dim :: Int, index :: Int) :: Vector
    v = zeros(Int, dim)
    v[index] = 1
    return v
end

function tourWeight(adjacencyMatrix :: Matrix{T}, tour :: Vector{Int}) :: T where T <: Real
    basis = basisVector.(size(adjacencyMatrix)[1], [tour; view(tour, 1)])
    left  = basis[1:end-1] |> stack |> sparse # |> CuSparseMatrixCSC
    right = basis[2:end]   |> stack |> transpose |> sparse # |> CuSparseMatrixCSC
    mat   = left * adjacencyMatrix * right
    # display(mat)
    return tr(mat)
end

mat = [0 2 3; 4 0 6; 7 8 0]
permutationVector = [[1,2,3],[2,1,3],[3,2,1],[1,3,2],[2,3,1],[3,1,2]]
# # tour = [2,3,1]
(tour -> println("tour: $tour tour weight: ", tourWeight(mat, tour))).(permutationVector)
# tourWeight(mat, tour) |> display