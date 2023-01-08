class_name Anagram extends BaseMinigame

onready var prompt_word_label = get_node("%prompt_word_label")
onready var response_label = get_node("%response_label")

var correct_word := ""
var jumbled_word := ""

func _ready() -> void:
	connect("minigame_complete", self, "_handle_minigame_complete")

	# Set up word target
	correct_word = word_utils.get_random_words(1, 4, 6)[0]
	
	jumbled_word = correct_word

	# Here, we need to make sure the word is scrambled (i.e. not equal to the original word)
	# Also, at least 25% of the characters need to be in the correct position, and at max, 60%

	while not _jumbled_okay():
		jumbled_word = jumble(correct_word)

	var bbcode_jumbled_word = ""
	for idx in range(len(jumbled_word)):
		if jumbled_word[idx] == correct_word[idx]:
			bbcode_jumbled_word += set_bbcode_color_string(jumbled_word[idx], correct_position_color)
		else:
			bbcode_jumbled_word += set_bbcode_color_string(jumbled_word[idx], neutral_color)

	prompt_word_label.parse_bbcode("  " + bbcode_jumbled_word)
	response_label.text = "> " + player_str
	print("CORRECT_WORD " + correct_word)

	start_minigame()


func jumble(input_str: String) -> String:
	var input_string_as_array = []
	for each_character in input_str:
		input_string_as_array.append(each_character)
	
	var jumbled_string = ""

	while len(input_string_as_array) > 0:
		jumbled_string += input_string_as_array.pop_at(randi() % input_string_as_array.size())
	return jumbled_string


func _jumbled_okay() -> bool:
	var idx = 0
	var correct_places = 0
	while idx < len(correct_word):
		if correct_word[idx] == jumbled_word[idx]:
			correct_places += 1
		idx += 1

	var word_correctness = float(correct_places) / float(len(correct_word)) 

	if word_correctness >= 0.35 and word_correctness <= 0.6:
		return true
	
	return false


func _handle_player_str_updated(key_not_valid: bool) -> void:
	if len(player_str) > len(correct_word):
		print("TODO: HANDLE BLOCKING")
		return

	response_label.text = "> " + player_str

	# Detect the win
	if player_str == correct_word:
		finish_minigame()


func _handle_minigame_complete() -> void:
	var bbcode_player_str = set_bbcode_color_string(player_str, correct_position_color)
	response_label.parse_bbcode("> " + bbcode_player_str)