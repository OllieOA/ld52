extends Node

const MAX_DEVIATION = 5.0
var lerp_time := 1.0

onready var pos_tween = get_node("pos_tween")

var node_ref
var target_offset := Vector2.ZERO

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	pos_tween.connect("tween_all_completed", self, "_replay_tween")


func inject_ref(node_reference) -> void:
	node_ref = node_reference
	pos_tween.emit_signal("tween_all_completed")  # Start it off


func _get_new_target_offset() -> void:
	var new_target_x = rng.randf_range(-MAX_DEVIATION, MAX_DEVIATION)
	var new_target_y = rng.randf_range(-MAX_DEVIATION, MAX_DEVIATION)
	target_offset = Vector2(new_target_x, new_target_y)


func _replay_tween() -> void:
	_get_new_target_offset()
	lerp_time = rng.randf_range(1.0, 5.0)
	pos_tween.interpolate_property(
			node_ref,
			"PulseOffset",
			node_ref.PulseOffset,
			target_offset,
			lerp_time,
			pos_tween.TRANS_SINE,
			pos_tween.EASE_IN_OUT
	)
	pos_tween.start()
