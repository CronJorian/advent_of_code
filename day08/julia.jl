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

function solution02(forest::Matrix{Int})
    max_scenic_score = 0
    for row in 2:size(forest)[2]-1
        for col in 2:size(forest)[1]-1
            scores = Dict("left"=>0,"right"=>0,"above"=>0,"below"=>0)
            for left in col-1:-1:1
                scores["left"] += 1
                if forest[row,left] >= forest[row,col]
                    break
                end
            end
            for right in col+1:size(forest)[1]
                scores["right"] += 1
                if forest[row,right] >= forest[row,col]
                    break
                end
            end
            for above in row-1:-1:1
                scores["above"] += 1
                if forest[above,col] >= forest[row,col]
                    break
                end
            end
            for below in row+1:size(forest)[2]
                scores["below"] += 1
                if forest[below,col] >= forest[row,col]
                    break
                end
            end
            max_scenic_score = max(prod(collect(values(scores))), max_scenic_score)
        end
    end
    return max_scenic_score
end

@assert solution01(get_forest(input)) == 1785
@assert solution02(get_forest(input)) == 345168