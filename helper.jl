function read_file(path::String)::AbstractString
    file = open(path, "r")
    input = read(file, String)
    close(file)
    input
end