include("../helper.jl")
input = read_file("./day10/input.txt")
test_input = read_file("./day10/test_input.txt")

function parse_input(input::AbstractString)
    map(row -> (row[1], length(row) == 1 ? 0 : parse(Int, row[2])), split.(split(input, "\n")))
end

function print_solution(crt::AbstractString)
    for cycles in [1:40, 41:80, 81:120, 121:160, 161:200, 201:239]
        println(crt[cycles])
    end    
end

function solution01(input::AbstractString)
    register = Dict{Integer, Integer}() # Cycle, register
    X = 1
    cycle = 0.5 # 0.5 means between cycle 0 and 1
    next_important_cycle = 20
    accumulator = 0

    for (command, value) in parse_input(input)
        if cycle > next_important_cycle isnothing(get(register, next_important_cycle, nothing))
            register[next_important_cycle] = X
            next_important_cycle += 40
        end
        X += accumulator
        accumulator = 0

        if command == "noop"
            cycle += 1
        elseif command == "addx"
            cycle += 2
            accumulator = value
        end
    end
    sum(map(((x,y),) -> x*y, collect(register)))
end

function solution02(input::AbstractString)
    cycle = 0
    pixels = ""
    middle_position = 2
    accumulator = 0
    
    for (command, value) in parse_input(input)
        for step in mod.((length(pixels)+1):cycle, 40)
            pixels *= in(step, middle_position-1:middle_position+1) ? "#" : "."
        end
        if (accumulator != 0)
            println(middle_position)
        end

        middle_position += accumulator
        accumulator = 0

        if command == "noop"
            cycle += 1
        elseif command == "addx"
            cycle += 2
            accumulator = value
        end
    end
    print_solution(pixels)
end

@assert solution01(test_input) == 13140
solution01(input)
solution02(input)

