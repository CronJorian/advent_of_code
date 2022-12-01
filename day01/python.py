import numpy as np
import os

def solution01():
    with open("./day01/input.txt") as f:
        example_input=f.read()
    
    print(
        np.array(
            [
                np.array(items.split("\n"), dtype=int).sum()
                for items in example_input.split("\n\n")
            ]
        ).max()
    )

def main():
    solution01()

if __name__ == "__main__":
    main()
