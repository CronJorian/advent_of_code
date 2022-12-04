function evaluate_round(enemy_choice::String, player_choice::String)::Int
    score = 0
    if player_choice == "X"
        score += 1
        if enemy_choice == "A"
            score += 3
        elseif enemy_choice == "C"
            score += 6
        end
    elseif player_choice == "Y"
        score += 2
        if enemy_choice == "B"
            score += 3
        elseif enemy_choice == "A"
            score += 6
        end
    elseif player_choice == "Z"
        score += 3
        if enemy_choice == "C"
            score += 3
        elseif enemy_choice == "B"
            score += 6
        end
    end
    return score
end

file = open("./day02/input.txt", "r")
input = read(file, String)
close(file)

function solution01(input::String)
    plays = split.(split(input, "\n"), " ")
    return mapreduce(x -> evaluate_round(String(x[1]), String(x[2])), +, plays)
end

solution01(input)