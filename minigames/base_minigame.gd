class_name BaseMinigame extends Panel

signal minigame_complete(score)
signal player_str_updated(key_not_valid)

enum MinigameType {
	ANAGRAM,
	PROMPT,
	GRID,
	HACK,
	CAPITALS,
	HANGMAN,
	COUNTDOWN,  # doesn't match the feel
	ALPHABET,
	NUMBERS,
	LONGEST,
	SHORTEST,
	SPELLING  # on fence
}

var keys_pressed := {}  # TODO: Extend this structure into limited special chars
var can_backspace := true

var player_str := ""

var minigame_active := false
var word_utils = preload("res://utils/word_utils.tres") as WordUtils
var color_text_utils = preload("res://utils/color_text_utils.tres") as ColorTextUtils


func _ready() -> void:
	randomize()
	connect("player_str_updated", self, "_handle_player_str_updated")
	for each_scancode in word_utils.valid_scancodes:
		keys_pressed[each_scancode] = false


func _unhandled_input(event: InputEvent) -> void:
	if not minigame_active:
		return
	if event.is_action_pressed("backspace_word") and can_backspace:
		player_str = player_str.substr(0, len(player_str) - 1)
		emit_signal("player_str_updated", false)
	elif event is InputEventKey:
		if event.scancode in word_utils.valid_scancodes:
			if not keys_pressed[event.scancode]:  # Check if currently pressed - prevents double keys
				keys_pressed[event.scancode] = true
				var key_typed = ""
				key_typed = OS.get_scancode_string(event.scancode)
				player_str += key_typed
				emit_signal("player_str_updated", key_typed == "")

			elif not event.is_pressed():  # Allow the key to be pressed again
				keys_pressed[event.scancode] = false


func start_minigame() -> void:
	minigame_active = true


func finish_minigame() -> void:
	minigame_active = false
	emit_signal("minigame_complete")


func _handle_player_str_updated(key_not_valid) -> void:
	pass  # TO BE OVERLOADED
