function solution01(input::String)::Int
    raw_lists = split(input, "\n\n")
    elves_calories = map(text -> parse.(Int, split(text, "\n")), raw_elves_list)
    total_calories = sum.(elves_list_parsed)
    return maximum(total_calories)
end

function solution02(input::String)
    raw_lists = split(input, "\n\n")
    elves_calories = map(text -> parse.(Int, split(text, "\n")), raw_elves_list)
    total_calories = sum.(elves_list_parsed)
    return sum(sort(total_calories, rev=true)[1:3])
end

file = open("./day01/input.txt", "r")
input = read(file, String)
close(file)

@assert solution01(input) == 67450
@assert solution02(input) == 199357
