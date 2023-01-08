class_name Alphabet extends BaseMinigame

onready var alpha_text = get_node("%alpha_text")

var correct_word := ""
var curr_index := 0

const LINEBREAKS = [
	"H",
	"Q"
]

func _ready() -> void:
	for character in word_utils.alphabet:
		correct_word += character

	can_backspace = false
	# Update color
	var full_bbcode_str = _build_bbcode_alpha_string()
	alpha_text.parse_bbcode(full_bbcode_str)
	start_minigame()
	

func _build_bbcode_alpha_string() -> String:
	var full_bbcode_str = "[center]"
	full_bbcode_str += color_text_utils.set_bbcode_color_string("> ", color_text_utils.neutral_color)
	full_bbcode_str += color_text_utils.set_bbcode_color_string(player_str, color_text_utils.correct_position_color)
	full_bbcode_str += color_text_utils.set_bbcode_color_string(correct_word.substr(curr_index), color_text_utils.inactive_color)
	full_bbcode_str += "[/center]"

	for linebreak in LINEBREAKS:
		var linebreak_idx = full_bbcode_str.find(linebreak)

		var completed_portion = full_bbcode_str.substr(0, linebreak_idx + 1)
		var incomplete_portion = full_bbcode_str.substr(linebreak_idx + 1, len(full_bbcode_str))
		full_bbcode_str = completed_portion + "\n" + incomplete_portion

	return full_bbcode_str


func _handle_player_str_updated(key_not_valid: bool) -> void:
	var correct_key = correct_word[curr_index]

	if key_not_valid:
		pass  # TODO: Handle invalid key
	elif player_str[-1] != correct_key:
		player_str = player_str.substr(0, len(player_str) - 1)
	else:
		curr_index += 1

	# Update color
	var full_bbcode_str = _build_bbcode_alpha_string()
	alpha_text.parse_bbcode(full_bbcode_str)

	if player_str == correct_word:
		print("FIN")
		finish_minigame()
