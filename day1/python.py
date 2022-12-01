example_input = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""


def list_from_input(input: str):
    return input.splitlines()


def get_max_index(input_liste: list[str]):
    max_total_calories = None
    best_elf = None
    
    current_calories = 0
    current_elf = 1

    for calories in input_liste:
        try:
            calories_as_number = int(calories)
            current_calories += calories_as_number
        except:
            if max_total_calories == None or current_calories > max_total_calories:
                max_total_calories = current_calories
                best_elf = current_elf
                current_calories = 0
            current_elf += 1

    return best_elf


def main():
    l = list_from_input(example_input)
    print(get_max_index(l))

if __name__ == "__main__":
    main()
