import json

MIN_LEN = 4
MAX_LEN = 7

SKIP_FIRST = 500
TARGET_LEN = 2000


def main() -> None:
    input_file = "wiki-100k.txt"

    with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
        words = []
        for x in f.readlines():
            try:
                words.append(x.strip())
            except UnicodeDecodeError:
                continue

    target_words = []

    for idx, word in enumerate(words):
        if idx < SKIP_FIRST:
            continue
        if word.startswith("#"):
            continue
        if len(word) > MAX_LEN or len(word) < MIN_LEN:
            continue
        if not all([x.isalpha() for x in word]):
            continue

        target_words.append(word.lower())

        if len(target_words) > TARGET_LEN:
            break

    with open("wordlist.json", "w") as j:
        json.dump(target_words, j, indent=4)


if __name__ == "__main__":
    main()
