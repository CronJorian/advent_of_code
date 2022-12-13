file = open("./day08/input.txt", "r")
input = read(file, String)
close(file)

test_input = raw"""30373
25512
65332
33549
35390"""

get_forest(input) = mapreduce(permutedims, vcat, map(row -> parse.(Int, row), collect.(split(input, "\n"))))

function solution01(forest::Matrix{Int})
    invisible_counter = 0
    for row in 2:size(forest)[2]-1
        for col in 2:size(forest)[1]-1
            left = all(isless.(forest[row, begin:col-1], forest[row, col]))
            right = all(isless.(forest[row, col+1:end], forest[row, col]))
            above = all(isless.(forest[begin:row-1, col], forest[row, col]))
            below = all(isless.(forest[row+1:end, col], forest[row, col]))

            if !any([left, right, above, below])
                invisible_counter += 1
            end
        end
    end
    return prod(size(forest)) - invisible_counter
end

@assert solution01(get_forest(input)) == 1785