class_name Level extends Node2D

# Handle signals

# Get relevant nodes
onready var game_ui = get_node("%game_ui")
onready var site_network = get_node("%site_network")
onready var player_camera = get_node("%player_camera")
onready var firewall = get_node("%firewall")

var firewall_speed_multiplier := 1.0

# Handle score
var curr_score := 0

# Handle states
enum GameStates {
	ARRIVING_AT_NODE,
	SELECTING_NODE,
	PLAYING_MINIGAME,
	TRAVERSING,
}

var game_state = GameStates.ARRIVING_AT_NODE


func _ready() -> void:
	# Connect relevant signals
	SignalBus.connect("website_completed", self, "_handle_website_completed")

	# Set up firewall
	firewall.set_acceleration_multiplier(firewall_speed_multiplier)  # Used to speed up later (or stop movement for tutorial)



# Signal callbacks
func _handle_website_completed(website_id: int, score: int) -> void:
	curr_score += score
	game_ui.set_score(curr_score)