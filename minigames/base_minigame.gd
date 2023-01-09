class_name BaseMinigame extends Panel

signal minigame_complete(score)
signal player_str_updated(key_not_valid)

signal good_key()
signal bad_key()

onready var good_type_sound = get_node("%good_type_sound")
onready var bad_type_sound = get_node("%bad_type_sound")

enum MinigameType {
	ANAGRAM,
	# PROMPT,
	# GRID,
	# HACK,
	CAPITALS,
	# HANGMAN,
	ALPHABET,
	# NUMBERS,
	# LONGEST,
	# SHORTEST,
}

var keys_pressed := {}  # TODO: Extend this structure into limited special chars
var can_backspace := true

var player_str := ""

var minigame_active := false
var word_utils = preload("res://utils/word_utils.tres") as WordUtils
var color_text_utils = preload("res://utils/color_text_utils.tres") as ColorTextUtils

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	var _na = connect("player_str_updated", self, "_handle_player_str_updated")
	_na = connect("good_key", self, "_play_good_key")
	_na = connect("bad_key", self, "_play_bad_key")

	for each_scancode in word_utils.valid_scancodes:
		keys_pressed[each_scancode] = false


func _unhandled_input(event: InputEvent) -> void:
	if not minigame_active:
		return

	if event.is_action_pressed("debug_skip_minigame"):
		finish_minigame()

	if event.is_action_pressed("backspace_word") and can_backspace:
		player_str = player_str.substr(0, len(player_str) - 1)
		emit_signal("player_str_updated", false)
	elif event is InputEventKey:
		if event.scancode in word_utils.alpha_scancodes:
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


func _play_good_key() -> void:
	good_type_sound.pitch_scale = rng.randf_range(0.95, 1.05)
	good_type_sound.play()


func _play_bad_key() -> void:
	bad_type_sound.play()