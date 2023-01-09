import cv2
import numpy as np
import random


NOISE_SIZE_X = 64
NOISE_SIZE_Y = NOISE_SIZE_X * 8
SCALE_FACTOR = 8

PROG_NOISE_Y = 8
PROG_NOISE_X = 32 * PROG_NOISE_Y
PROG_SCALE_FACTOR = 4


def main():
    random.seed(69)
    matrix = np.zeros((NOISE_SIZE_Y, NOISE_SIZE_X))

    for x in range(matrix.shape[0]):
        for y in range(matrix.shape[1]):
            matrix[x, y] += random.randint(0, 255)

    matrix = cv2.resize(
        matrix,
        (NOISE_SIZE_X * SCALE_FACTOR, NOISE_SIZE_Y * SCALE_FACTOR),
        interpolation=cv2.INTER_NEAREST,
    )

    cv2.imwrite("assets/pixel_noise.png", matrix)

    # Make one for the progressbar

    prog_bar = np.zeros((PROG_NOISE_Y, PROG_NOISE_X))
    for x in range(prog_bar.shape[0]):
        for y in range(prog_bar.shape[1]):
            prog_bar[x, y] += random.randint(0, 255)

    prog_bar = cv2.resize(
        prog_bar,
        (PROG_NOISE_X * PROG_SCALE_FACTOR, PROG_NOISE_Y * PROG_SCALE_FACTOR),
        interpolation=cv2.INTER_NEAREST,
    )

    cv2.imwrite("assets/progress_noise.png", prog_bar)


if __name__ == "__main__":
    main()
