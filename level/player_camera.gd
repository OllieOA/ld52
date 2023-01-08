extends Camera2D


const LERP_SPEED = 0.5

var target_position = 


func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func sharp_goto_position(set_position: Vector2) -> void:
	target_position = set_position
	position = set_position


func smooth_goto_position(set_position: Vector2) -> void:
	target_position = set_position