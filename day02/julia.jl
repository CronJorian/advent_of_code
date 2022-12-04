function evaluate_round(enemy_choice::String, player_choice::String)::Int
    p = player_choice == "X" ? 1 : (player_choice == "Y" ? 2 : (player_choice == "Z" ? 3 : 0))
    e = enemy_choice == "A" ? 1 : (enemy_choice == "B" ? 2 : (enemy_choice == "C" ? 3 : 0))
    g = mod(p - e + 1, 3) * 3 + p

    return g
end

function get_player_choice(enemy_choice::String, wanted_outcome::String)
    # wanted_outcome: X := lose, Y := draw, Z := win
    e = enemy_choice == "A" ? 1 : (enemy_choice == "B" ? 2 : (enemy_choice == "C" ? 3 : 0))
    w = wanted_outcome == "X" ? 2 : (wanted_outcome == "Y" ? 1 : (wanted_outcome == "Z" ? 3 : 0))

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