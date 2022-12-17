file = open("./day09/input.txt", "r")
input = read(file, String)
close(file)

test_input = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

test_input_2 = """R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"""

mutable struct Knot
    x::Int
    y::Int
    successor::Union{Knot,Nothing}
    visited_points::Vector{Tuple{Int,Int}}
end

function pull_knot(knot::Knot, predecessor::Knot)
    dx, dy = (knot.x - predecessor.x, knot.y - predecessor.y)
    if !all([-1 <= dx <= 1, -1 <= dy <= 1])
        knot.x, knot.y = (knot.x - sign(dx), knot.y - sign(dy))
    end

    push!(knot.visited_points, (knot.x, knot.y))

    if !isnothing(knot.successor)
        pull_knot(knot.successor, knot)
    end
end

function move_knot(knot::Knot, direction::AbstractString)
    if direction == "L"
        knot.x, knot.y = (knot.x - 1, knot.y)
    elseif direction == "R"
        knot.x, knot.y = (knot.x + 1, knot.y)
    elseif direction == "D"
        knot.x, knot.y = (knot.x, knot.y - 1)
    elseif direction == "U"
        knot.x, knot.y = (knot.x, knot.y + 1)
    end

    push!(knot.visited_points, (knot.x, knot.y))

    if !isnothing(knot.successor)
        pull_knot(knot.successor, knot)
    end
end

function parse_input(input::String)
    map(((direction, steps),) -> [direction, parse(Int, steps)], split.(split(input, "\n")))
end

function move_rope(moves, head)
    for (direction, steps) in moves
        for _ in 1:steps
            move_knot(head, direction)
        end
    end
    head
end

function create_rope(num_knots)
    head = nothing
    for knot in 1:num_knots
        head = Knot(0, 0, head, [])
    end

    head
end

function solutions(input, num_knots)
    moves = parse_input(input)
    head = create_rope(num_knots)
    tail = move_rope(moves, head)
    while true
        if !isnothing(tail.successor)
            tail = tail.successor
        else
            break
        end
    end
    length(Set(tail.visited_points))
end

solution01 = solutions(input, 2)
solution02 = solutions(input, 10)