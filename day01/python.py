import numpy as np
import os


def solution01():
    with open("./day01/input.txt") as f:
        example_input = f.read()

    print(
        np.array(
            [
                np.array(items.split("\n"), dtype=int).sum()
                for items in example_input.split("\n\n")
            ]
        ).max()
    )


def solution02():
    with open("./day01/input.txt") as f:
        example_input = f.read()

    print(
        np.sort(
            [
                np.array(items.split("\n"), dtype=int).sum()
                for items in example_input.split("\n\n")
            ]
        )[-3:].sum()
    )


def main():
    solution01()
    solution02()


if __name__ == "__main__":
    main()
