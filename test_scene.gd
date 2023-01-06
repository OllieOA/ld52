extends Control

export (NodePath) onready var target_label = get_node(target_label) as Label
export (NodePath) onready var target_button = get_node(target_button) as Button

func _ready() -> void:
	target_button.connect("button_down", self, "on_button_down")
	target_button.connect("button_up", self, "on_button_up")

func on_button_down():
	target_label.show()

func on_button_up():
	target_label.hide()
