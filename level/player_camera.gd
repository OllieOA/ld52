extends Camera2D

onready var pos_tween = get_node("%pos_tween")

const LERP_SPEED = 0.2


func _ready() -> void:
	pass


func _use_pos_tween(target_pos):
	pos_tween.interpolate_property(
		self,
		"global_position",
		global_position,
		target_pos,
		LERP_SPEED,
		pos_tween.TRANS_SINE,
		pos_tween.EASE_OUT
	)
	pos_tween.start()


func sharp_goto_position(set_position: Vector2) -> void:
	global_position = set_position


func smooth_goto_position(set_position: Vector2) -> void:
	_use_pos_tween(set_position)