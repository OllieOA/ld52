extends Control

onready var start_minigame_button = get_node("%start_minigame_button")
export var (Minigame.MinigameType) minigame_type

func _ready() -> void:
	start_minigame_button.connect("button_up", self, "_start_minigame")
	pass 

func _start_minigame() -> void:
	pass
