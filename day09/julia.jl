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

parse_input(input) = map(((direction, steps),) -> (direction, parse(Int, steps)), split.(split(input, "\n")))

function move_head(head_state::Tuple{Int,Int}, direction::AbstractString)::Tuple{Int,Int}
    x, y = head_state

    if direction == "L"
        return (x - 1, y)
    elseif direction == "R"
        return (x + 1, y)
    elseif direction == "U"
        return (x, y + 1)
    elseif direction == "D"
        return (x, y - 1)
    end
end

function pull_tail(head_state::Tuple{Int,Int}, tail_state::Tuple{Int,Int})::Tuple{Int,Int}
    hx, hy = head_state
    tx, ty = tail_state

    dx, dy = (hx - tx, hy - ty)
    if -1 <= dx <= 1 && -1 <= dy <= 1
        return tail_state
    elseif dx != 0 && dy != 0
        return (tx + copysign(1, dx), ty + copysign(1, dy))
    else
        return (dy == 0 ? tx + copysign(1, dx) : tx, dx == 0 ? ty + copysign(1, dy) : ty)
    end
end

function move_rope(state::Tuple{Tuple{Int,Int},Tuple{Int,Int}}, direction::AbstractString, steps::Int)
    head_state, tail_state = state
    visited_positions = Dict{String,Vector{Tuple{Int,Int}}}("head" => [], "tail" => [])

    for _ in 1:steps
        head_state = move_head(head_state, direction)
        push!(visited_positions["head"], head_state)
        tail_state = pull_tail(head_state, tail_state)
        push!(visited_positions["tail"], tail_state)
    end
    (head_state, tail_state), visited_positions
end

function solution01(moves)
    state = ((0, 0), (0, 0))
    visited_positions = Dict{String,Vector{Tuple{Int,Int}}}("head" => [], "tail" => [])

    for (direction, steps) in moves
        state, new_positions = move_rope(state, direction, steps)
        mergewith(append!, visited_positions, new_positions)
    end
    Set(visited_positions["tail"])
end

@assert length(solution01(parse_input(test_input))) == 13
@assert length(solution01(parse_input(input))) == 5683
