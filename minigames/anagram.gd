class_name Anagram extends BaseMinigame

onready var prompt_word_label = get_node("%prompt_word_label")
onready var response_label = get_node("%response_label")

var correct_word := ""
var jumbled_word := ""

func _ready() -> void:
	correct_word = get_random_words(1)[0]
	
	jumbled_word = correct_word

	# Here, we need to make sure the word is scrambled (i.e. not equal to the original word)
	# Also, at least 25% of the characters need to be in the correct position

	while not _jumbled_okay():
		jumbled_word = jumble(correct_word)

	prompt_word_label.text = jumbled_word
	

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

	var word_correctness =float(correct_places) / float(len(correct_word)) 

	if word_correctness >= 0.25 and word_correctness <= 0.6:
		return true
	
	return false


func _handle_player_str_updated() -> void:
	response_label.text = "> " + player_str
	print("UPDATED TO " + player_str)
