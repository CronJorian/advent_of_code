test_input = raw"""$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""

file = open("./day07/input.txt", "r")
input = read(file, String)
close(file)

function change_directory(current_directory, command)
  if command == "/"
    return ["\\"]
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
  current_directory = ["\\"]
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


function solution01(input::String)
  commands = split.(split(test_input, "\n"))
  build_tree(commands)  
end

commands = split.(split(test_input, "\n"))

function walk_directory(dict, current_directory)
  fs = Dict{AbstractString, Integer}()

  for (key, value) in dict
    println(joinpath(current_directory..., key))
    if isa(value, Dict)
      fs[joinpath(current_directory..., key)] = get_size(value)
      walk_directory(get_nested_value(fs, [current_directory..., key]), [current_directory..., key])
    end
  end
  return fs
end

build_tree(commands)
