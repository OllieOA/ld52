class_name BaseMinigame extends Panel

signal minigame_complete(score)

enum MinigameType {
	ANAGRAM,
	PROMPT,
	GRID,
	HACK
}


const minigame_lookup = {
	MinigameType.ANAGRAM: "res://minigames/anagram.tscn",
	MinigameType.PROMPT: "res://minigames/prompt.tscn",
	MinigameType.GRID: "res://minigames/grid.tscn",
	MinigameType.HACK: "res://minigames/hack.tscn",
}

var minigame_started := false
var word_list = load("res://minigames/word_list.tres") as WordList

func _ready() -> void:
	randomize()
	word_list.generate_word_list()


func _process(delta: float) -> void:
	if minigame_started:
		pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()


func get_random_words(target_length: int) -> Array:
	var strings = []

	while len(strings) < target_length:
		var rand_choice = word_list.word_list[randi() % word_list.word_list.size()]
		if not rand_choice in strings:
			strings.append(rand_choice)
	
	return strings



func start_minigame() -> void:
	minigame_started = true
		