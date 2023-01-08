class_name Capitals extends BaseMinigame

onready var prompt_text = get_node("%prompt_text")

const TEXTBOX_SIZE = 56
const LINE_WIDTH = 14

var correct_word := ""
var noise_string := ""
var curr_index := 0

var insert_indices := []

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	correct_word = word_utils.get_random_words(1, 6, 8)[0]
	print(correct_word)
	can_backspace = false

	noise_string = "> "
	while len(noise_string) < TEXTBOX_SIZE:
		noise_string += word_utils.alphabet[randi() % len(word_utils.alphabet)].to_lower()

	while len(insert_indices) < len(correct_word):
		var rand_index = rng.randi_range(5, TEXTBOX_SIZE-1)
		if not rand_index in insert_indices:
			insert_indices.append(rand_index)

	insert_indices.sort()

	for idx in range(len(correct_word)):
		noise_string[insert_indices[idx]] = correct_word[idx]

	# Insert newlines
	var broken_lines = []
	while len(noise_string) > 0:
		var removed_string = noise_string.left(LINE_WIDTH)
		broken_lines.append(removed_string + "\n")
		noise_string.erase(0, LINE_WIDTH)

	for line in broken_lines:
		noise_string += line

	# Rebuild insert_indices
	insert_indices = []
	for idx in range(len(noise_string)):
		if noise_string[idx] in word_utils.alphabet:
			insert_indices.append(idx)

	var full_bbcode_str = _build_bbcode_capitals()
	prompt_text.parse_bbcode(full_bbcode_str)
	start_minigame()


func _build_bbcode_capitals() -> String:
	var full_bbcode_str = ""
	var prev_index := 0
	for idx in range(curr_index):
		var target_substr = noise_string.substr(prev_index, insert_indices[idx] - prev_index)
		var target_char = noise_string[insert_indices[idx]]
		prev_index = insert_indices[idx] + 1

		full_bbcode_str += set_bbcode_color_string(target_substr, inactive_color)
		full_bbcode_str += set_bbcode_color_string(target_char, correct_position_color)

	if curr_index == len(correct_word):
		full_bbcode_str += set_bbcode_color_string(noise_string.substr(prev_index), inactive_color)
	else:
		full_bbcode_str += set_bbcode_color_string(noise_string.substr(prev_index), neutral_color)

	return full_bbcode_str


func _handle_player_str_updated(key_not_valid: bool) -> void:
	var correct_key = correct_word[curr_index]

	if key_not_valid:
		pass  
	elif player_str[-1] != correct_key:
		player_str = player_str.substr(0, len(player_str) - 1)
	else:
		curr_index += 1

	# Update color
	var full_bbcode_str = _build_bbcode_capitals()
	prompt_text.parse_bbcode(full_bbcode_str)

	if player_str == correct_word:
		print("FIN")
		finish_minigame()
