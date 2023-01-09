class_name ClickingButton extends Button

onready var button_click_sound = get_node("%button_click_sound") as AudioStreamPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	var _na = connect("button_down", self, "on_button_down")


func on_button_down() -> void:
	button_click_sound.pitch_scale = rand_range(0.9, 1.1)
	button_click_sound.play()
