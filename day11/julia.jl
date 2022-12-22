include("../helper.jl")
test_input = read_file("./day11/test_input.txt")
input = read_file("./day11/input.txt")

struct Monkey
    id::Int
    items::Vector{Int128}
    operation::Function
    modulo::Int
    test::Function
    throw_true::Int
    throw_false::Int
end

function parse_input(input::AbstractString)::Vector{Monkey}
    monkeys = []
    input_monkeys = split(input, "\n\n")
    for monkey in input_monkeys
        monkey_lines = split(monkey, "\n  ")

        id = parse(Int, chop(split(monkey_lines[1])[end]))
        items = [parse(Int, word.match) for word in eachmatch(r"\b\d+\b", monkey_lines[2])]
        # requires old to be set before calling
        # old = items...
        operation = (old) -> eval(Meta.parse(replace(match(r"(?<=Operation: new = ).*$", monkey_lines[3]).match, "old" => "$old")))
        modulo = parse(Int, match(r"\d+$", monkey_lines[4]).match)
        test = (worry_level) -> mod(worry_level, modulo) == 0
        throw_true = parse(Int, match(r"\d+$", monkey_lines[5]).match)
        throw_false = parse(Int, match(r"\d+$", monkey_lines[6]).match)
        push!(monkeys, Monkey(id, items, operation, modulo, test, throw_true, throw_false))
    end
    monkeys
end

function do_rounds(monkeys::Vector{Monkey}, n_rounds::Int, relief=true)
    modulo = prod([monkey.modulo for monkey in monkeys])
    inspections = zeros(Int128, length(monkeys))
    for _ in 1:n_rounds
        for monkey in monkeys
            for item in monkey.items
                # Operation
                item = monkey.operation(item)
                inspections[monkey.id+1] += 1
                # Reduce to floor(x/3)
                if relief
                    item = convert(Int128, floor(item / 3))
                end
                item = mod(item, modulo)
                # Test / Throw
                test = monkey.test(item)
                new_monkey = test ? monkey.throw_true : monkey.throw_false
                push!(monkeys[new_monkey+1].items, item)
            end
            empty!(monkey.items)
        end
    end
    inspections
end

function solution01(input::AbstractString)
    monkeys = parse_input(input)
    inspections = do_rounds(monkeys, 20)
    prod(sort(inspections, rev=true)[begin:2])
end

function solution02(input::AbstractString)
    monkeys = parse_input(input)
    inspections = do_rounds(monkeys, 10000, false)
    prod(sort(inspections, rev=true)[begin:2])
end

@assert solution01(test_input) == 10605
@time solution01(input)
@assert solution02(test_input) == 2713310158
@time solution02(input)