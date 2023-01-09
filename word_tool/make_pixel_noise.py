import cv2
import numpy as np
import random


NOISE_SIZE_X = 64
NOISE_SIZE_Y = NOISE_SIZE_X * 8
SCALE_FACTOR = 8


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


if __name__ == "__main__":
    main()
