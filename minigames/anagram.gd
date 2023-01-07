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
	while not _check_jumbled_okay():
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


func _check_jumbled_okay() -> bool:
	var idx = 0
	var correct_places = 0
	while idx < len(correct_word):
		if correct_word[idx] == jumbled_word[idx]:
			correct_places += 1
		idx += 1

	print("Word len " + correct_word)

	print(jumbled_word)
	print(correct_places)

	if float(correct_places / len(correct_word)) >= 0.25 and len(correct_word) > correct_places:
		return true
	
	return false

