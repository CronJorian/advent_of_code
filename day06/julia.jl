file = open("./day06/input.txt", "r")
input = read(file, String)
close(file)

function find_marker(input::String, marker_length::Int)::Int
  i = marker_length
  while i < length(input)
    if allunique(input[i-marker_length+1:i])
      println("Marker $(input[i-marker_length+1:i]) found at $i")
      return i
    else
      i += 1
    end
  end
end

solution01(input) = find_marker(input, 4)
solution02(input) = find_marker(input, 14)

solution01(input)
solution02(input)

