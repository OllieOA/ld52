class_name Firewall extends Node2D

onready var debug_speed_label = get_node("%debug_speed_label")

# Firewall movement mechanics
var firewall_acceleration := 0.005
var firewall_acceleration_multiplier := 1.0
var firewall_speed := 0.02
var firewall_max_speed := 1

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	firewall_speed = clamp(firewall_speed + (delta * firewall_acceleration * firewall_acceleration_multiplier), 0, firewall_max_speed)
	global_position.x += firewall_speed

	debug_speed_label.text = str(firewall_speed)


func set_acceleration_multiplier(multiplier: float) -> void:
	firewall_acceleration_multiplier = multiplier


func set_x_position(x_pos: int) -> void:
	global_position.x = x_pos