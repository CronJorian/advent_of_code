file = open("./day07/input.txt", "r")
input = read(file, String)
close(file)

function change_directory(current_directory, command)
  if command == "/"
    return ["/"]
  elseif command == ".."
    return current_directory[:1:length(current_directory)-1]
  else
    return [current_directory..., command]
  end
end

function get_nested_value(dict, keys)
  return reduce((init, key) -> get!(init, key, Dict{String,Any}()), keys, init=dict)
end

function build_tree(commands)
  fs = Dict{String,Any}()
  current_directory = ["/"]
  for command in commands
    if command[1] == "\$" && command[2] == "cd"
      current_directory = change_directory(current_directory, command[3])
    elseif command[1] == "dir"
      get_nested_value(fs, [current_directory..., command[2]])
    elseif isdigit(command[1][1])
      get_nested_value(fs, current_directory)[command[2]] = parse(Int128, command[1])
    end
  end
  return fs
end

function get_size(dict)
  size = 0
  for value in values(dict)
    if isa(value, Integer)
      size += value
    else
      size += get_size(value)
    end
  end
  return size
end

function walk_directory(dict, current_directory=nothing)
  fs = Dict{AbstractString,Integer}()

  if current_directory !== nothing
    fs[joinpath(current_directory...)] = get_size(dict)
  else
    current_directory = []
  end

  for (key, value) in dict
    if isa(value, Dict)
      merge!(fs, walk_directory(value, [current_directory..., key]))
    end
  end
  return fs
end

function solution01(input::String)
  commands = split.(split(input, "\n"))
  tree = build_tree(commands)
  sizes = walk_directory(tree)
  return sum(filter(size -> size <= 100000, collect(values(sizes))))
end

function solution02(input::String)
  available_space = 70000000
  update_size = 30000000

  commands = split.(split(input, "\n"))
  tree = build_tree(commands)
  sizes = walk_directory(tree)
  required_size = update_size - (available_space - sizes["/"])
  return minimum(filter(size -> size >= required_size, collect(values(sizes))))
end

@assert solution01(input) == 1443806
@assert solution02(input) == 942298