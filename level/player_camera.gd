extends Camera2D

const LERP_SPEED = 0.05

var mover_node  # Used as an anchor
var x_offset = 200  # Be a little ahead of the camera

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if mover_node != null:
		global_position = lerp(global_position, mover_node.global_position + Vector2(x_offset, 0), LERP_SPEED)


func sharp_goto_position(set_position: Vector2) -> void:
	global_position = set_position
