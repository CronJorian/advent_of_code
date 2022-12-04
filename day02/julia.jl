
function evaluate_round(enemy_choice::String, player_choice::String)::Int
    choice_dictionary = Dict(
        "A" => 1,
        "B" => 2,
        "C" => 3,
        "X" => 1,
        "Y" => 2,
        "Z" => 3
    )

    p = choice_dictionary[player_choice]
    e = choice_dictionary[enemy_choice]
    g = mod(p - e + 1, 3) * 3 + p

    return g
end

function get_player_choice(enemy_choice::String, wanted_outcome::String)
    choice_dictionary = Dict(
        "A" => 1,
        "B" => 2,
        "C" => 3,
        "X" => 2,
        "Y" => 1,
        "Z" => 3
    )
    # wanted_outcome: X := lose, Y := draw, Z := win
    e = choice_dictionary[enemy_choice]
    w = choice_dictionary[wanted_outcome]

    return string(Char(mod(e - w, 3)) + 88)
end


file = open("./day02/input.txt", "r")
input = read(file, String)
close(file)


function solution01(input::String)
    plays = split.(split(input, "\n"), " ")
    return mapreduce(x -> evaluate_round(String(x[1]), String(x[2])), +, plays)
end

function solution02(input::String)
    plays = split.(split(input, "\n"), " ")
    return mapreduce(x -> evaluate_round(String(x[1]), get_player_choice(String(x[1]), String(x[2]))), +, plays)
end

@assert solution01(input) == 11841
@assert solution02(input) == 13022