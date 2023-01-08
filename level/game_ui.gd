extends CanvasLayer


const MAX_SCORE_RENDERED = 9999999
const MAX_SAFE_DISTANCE = 1000

onready var firewall_proximity_meter = get_node("%firewall_proximity")
onready var data_label = get_node("%data_label")
onready var website_entry = get_node("%website_entry")
onready var website_entry_label = get_node("%website_entry_label")

onready var color_text_utils = preload("res://utils/color_text_utils.tres")

func _ready() -> void:
	var _na = SignalBus.connect("unique_match_found", self, "_handle_correct_input")
	_na = SignalBus.connect("no_str_matched", self, "_handle_no_str_matched")
	_na = SignalBus.connect("website_str_confirmed", self, "_handle_progress_input")
	_na = SignalBus.connect("triggered_minigame_prompt", self, "_handle_triggered_minigame_prompt")
	_na = SignalBus.connect("website_completed", self, "_handle_website_complete")


# Methods for updating ui
func set_website_label(bbcode_text: String) -> void:
	website_entry_label.parse_bbcode(bbcode_text)


func set_score(value: int) -> void:
	if value > MAX_SCORE_RENDERED:
		value = MAX_SCORE_RENDERED
	var score_as_str = str(value).pad_zeros(str(MAX_SCORE_RENDERED).length())
		
	var i : int = score_as_str.length() - 3
	while i > 0:
		score_as_str = score_as_str.insert(i, ",")
		i = i - 3
			
	var data_string = "Data: " + score_as_str
	data_label.text = data_string


func set_proximity(distance: int) -> void:
	# This updates both the caught timer string and the proximity meter
	# If time is greater than 1000 units, there is no proximity
	pass


# Signals
func _handle_correct_input(curr_string: String) -> void:
	var bbcode_text_to_add = color_text_utils.set_bbcode_color_string(curr_string, color_text_utils.correct_position_color)
	website_entry_label.parse_bbcode(bbcode_text_to_add)


func _handle_progress_input(curr_string: String) -> void:
	var bbcode_text_to_add = color_text_utils.set_bbcode_color_string(curr_string, color_text_utils.neutral_color_dark)
	website_entry_label.parse_bbcode(bbcode_text_to_add)


func _handle_no_str_matched(curr_string: String) -> void:
	var correct_part = color_text_utils.set_bbcode_color_string(curr_string.substr(0, len(curr_string) - 1), color_text_utils.neutral_color_dark)
	var incorrect_part = color_text_utils.set_bbcode_color_string(curr_string[-1], color_text_utils.incorrect_position_color)

	website_entry_label.parse_bbcode(correct_part + incorrect_part)


func _handle_triggered_minigame_prompt() -> void:
	print("HIDING")
	website_entry.hide()


func _handle_website_complete(_website_id, _data_scraped) -> void:
	website_entry.show()
