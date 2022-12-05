function parse_start(raw_start::Vector{SubString{String}})::Vector{SubString}
  slim_start = map(row -> row[2:4:end], raw_start)[begin:1:end-1]
  stacks = Vector{SubString}()
  for stack_id in 1:min(length.(slim_start)...)
    stack = ""
    for letter in reverse(slim_start)
      letter[stack_id] == ' ' && break # break on first whitespace
      stack *= letter[stack_id] # string concatenation
    end
    push!(stacks, stack)
  end
  return stacks
end

function parse_rearrangement(moves::Vector{SubString{String}})::Vector{Tuple{Int,Int,Int}}
  map(line -> tuple(parse.(Int, split(line)[2:2:end])...), moves)
end

function parse_input(input::String)::Tuple{Vector{SubString},Vector{Tuple{Int,Int,Int}}}
  raw_start, moves = split.(split(input, "\n\n"), "\n")
  parse_start(raw_start), parse_rearrangement(moves)
end

function process_move(state::Vector{SubString}, move::Tuple{Int,Int,Int}, crate_mover_9000::Bool)::Vector{SubString}
  cp_state = state
  items, from, to = move
  moved_stack = cp_state[from][end+1-items:end]
  if crate_mover_9000
    moved_stack = reverse(moved_stack)
  end
  cp_state[to] *= moved_stack
  cp_state[from] = cp_state[from][begin:end-items]
  cp_state
end

function process_moves(start::Vector{SubString}, moves::Vector{Tuple{Int,Int,Int}}, crate_mover_9000::Bool=true)
  cp_start = start
  for move in moves
    cp_start = process_move(start, move, crate_mover_9000)
  end
  cp_start
end

function get_top_crates(state::Vector{SubString})::String
  String(map(stack -> stack[end], state))
end

function solution01(input::String)::String
  start, moves = parse_input(input)
  end_state = process_moves(start, moves)
  get_top_crates(end_state)
end

function solution02(input::String)::String
  start, moves = parse_input(input)
  end_state = process_moves(start, moves, false)
  get_top_crates(end_state)
end

file = open("./day05/input.txt", "r")
input = read(file, String)
close(file)

@assert solution01(input) == "PTWLTDSJV"
@assert solution02(input) == "WZMFVGGZP"
