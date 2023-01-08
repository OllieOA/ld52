extends Camera2D

const LERP_SPEED = 0.05

var mover_node  # Used as an anchor
var x_offset = 150  # Be a little ahead of the camera

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if mover_node != null:
		global_position.x = lerp(global_position.x, mover_node.global_position.x + x_offset, LERP_SPEED)


func sharp_goto_position(set_position: Vector2) -> void:
	global_position = set_position
