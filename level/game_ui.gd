extends CanvasLayer


const MAX_SCORE_RENDERED = 99999999999
const MAX_SAFE_DISTANCE = 2000

onready var firewall_proximity_meter = get_node("%firewall_proximity")
onready var data_label = get_node("%data_label")
onready var website_entry = get_node("%website_entry")
onready var website_entry_label = get_node("%website_entry_label")
onready var shake_animator = get_node("%shake_animator")

onready var color_text_utils = preload("res://utils/color_text_utils.tres")

var curr_score := 0
var target_score := 0  # Target to move towards


func _ready() -> void:
	var _na = SignalBus.connect("unique_match_found", self, "_handle_correct_input")
	_na = SignalBus.connect("no_str_matched", self, "_handle_no_str_matched")
	_na = SignalBus.connect("website_str_confirmed", self, "_handle_progress_input")
	_na = SignalBus.connect("triggered_minigame_prompt", self, "_handle_triggered_minigame_prompt")
	_na = SignalBus.connect("website_completed", self, "_handle_website_complete")
	_na = SignalBus.connect("game_over", self, "_handle_game_over")
	_na = get_parent().connect("bad_key_level", self, "_handle_bad_key_level")

	firewall_proximity_meter.max_value = MAX_SAFE_DISTANCE


# Methods for updating ui
func set_website_label(bbcode_text: String) -> void:
	website_entry_label.parse_bbcode(bbcode_text)


func _process(_delta: float):
	curr_score = lerp(curr_score, target_score, 0.2)
	_update_score()


func set_score(value: int) -> void:
	if value > MAX_SCORE_RENDERED:
		value = MAX_SCORE_RENDERED

	target_score = value


func _update_score() -> void:
	var score_as_str = str(curr_score)#.pad_zeros(str(MAX_SCORE_RENDERED).length())
		
	var i : int = score_as_str.length() - 3
	while i > 0:
		score_as_str = score_as_str.insert(i, ",")
		i = i - 3
			
	var data_string = score_as_str + "\nData Harvested"
	data_label.text = data_string


func set_proximity(distance: int) -> void:
	# This updates both the caught timer string and the proximity meter
	# If time is greater than 1000 units, there is no proximity
	
	firewall_proximity_meter.value = clamp(MAX_SAFE_DISTANCE - distance, 0, MAX_SAFE_DISTANCE)


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
	website_entry.hide()


func _handle_website_complete(_website_id, _data_scraped) -> void:
	website_entry.show()


func _handle_bad_key_level() -> void:
	shake_animator.play("shake")


func _handle_game_over() -> void:
	hide()