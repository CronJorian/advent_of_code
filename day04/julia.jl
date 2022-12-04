file = open("./day04/input.txt", "r")
input = read(file, String)
close(file)

function is_in_range(left::Tuple{Int,Int}, right::Tuple{Int,Int})
    (right[1] <= left[1] <= right[2]) && (right[1] <= left[2] <= right[2]) ||
        (left[1] <= right[1] <= left[2]) && (left[1] <= right[2] <= left[2])
end

function is_overlapping(left::Tuple{Int,Int}, right::Tuple{Int,Int})
    !(left[2] < right[1] || right[2] < left[1])
end

function solution01(input::String)
    pairs = map(x -> parse.(Int, split(x, (',', '-'))), split(input, "\n"))
    count(pair -> is_in_range(tuple(pair[1:2]...), tuple(pair[3:4]...)), pairs)
end

function solution02(input::String)
    pairs = map(x -> parse.(Int, split(x, (',', '-'))), split(input, "\n"))
    count(pair -> is_overlapping(tuple(pair[1:2]...), tuple(pair[3:4]...)), pairs)
end

@assert solution01(input) == 433
@assert solution02(input) == 852
