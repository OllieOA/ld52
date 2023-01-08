extends CanvasLayer


const MAX_SCORE_RENDERED = 9999999

onready var time_to_die = get_node("%time_to_die")
onready var firewall_proximity_meter = get_node("%firewall_proximity")
onready var data_label = get_node("%data_label")


func _ready() -> void:
	pass


# Methods for updating ui

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


func set_proximity(seconds: int) -> void:
	# This updates both the caught timer string and the proximity meter
	# If time is greater than 120 seconds, there is no proximity
	pass