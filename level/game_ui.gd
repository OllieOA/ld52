extends CanvasLayer


const MAX_SCORE_RENDERED = 9999999
const MAX_SAFE_DISTANCE = 1000

onready var firewall_proximity_meter = get_node("%firewall_proximity")
onready var data_label = get_node("%data_label")
onready var website_entry_label = get_node("%website_entry_label")


func _ready() -> void:
	pass


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
	# If time is greater than 120 seconds, there is no proximity
	pass