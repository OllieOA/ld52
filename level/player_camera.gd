extends Camera2D

var lerp_speed = 0.05

var mover_node  # Used as an anchor
var x_offset = 150  # Be a little ahead of the camera
var y_offset = 0

var game_over := false

func _ready() -> void:
	var _na = SignalBus.connect("game_over", self, "_handle_game_over")


func _process(_delta: float) -> void:
	if mover_node != null and not game_over:
		global_position.x = lerp(global_position.x, mover_node.global_position.x + x_offset, lerp_speed)

	else:
		global_position.x = lerp(global_position.x, 0, 0.001)

func sharp_goto_position(set_position: Vector2) -> void:
	global_position = set_position


func _handle_game_over() -> void:
	game_over = true