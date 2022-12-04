get_priorities(text::SubString) = map(x -> x > 96 ? x - 96 : x - 64 + 26, collect(Int, text))
find_badge(priorities...) = intersect(priorities...)

function get_error_priority(text::SubString)
    priorities = get_priorities(text)
    left = priorities[1:length(priorities)÷2]
    right = priorities[length(priorities)÷2+1:length(priorities)]

    return sum(intersect(left, right))
end

file = open("./day03/input.txt", "r")
input = read(file, String)
close(file)

function solution01(input::String)
    backpacks = split(input, "\n")
    sum(get_error_priority.(backpacks))
end

function solution02(input::String)
    backpacks = split(input, "\n")
    priorities = get_priorities.(backpacks)
    groups = [priorities[i:i+2] for i in 1:3:length(priorities)]
    badges = map(group -> intersect(group...), groups)
    sum(vcat(badges...))
end

@assert solution01(input) == 7878
@assert solution02(input) == 2760