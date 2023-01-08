class_name Level extends Node2D


# Handle signals
signal example_signal

# Get relevant nodes
onready var game_ui = get_node("%game_ui")
onready var site_network = get_node("%site_network")
onready var mover_node = site_network.get_node("Mover")  # under the site network
onready var player_camera = get_node("%player_camera")
onready var firewall = get_node("%firewall")

# Handle minigames
const minigame_scene = preload("res://minigames/base_minigame_prompt.tscn")

# Handle firewall
var firewall_speed_multiplier := 1.0
const firewall_start_pos := -300

# Handle score
var curr_score := 0

# Handle states
enum GameStates {
	INITIALISING,
	ARRIVING_AT_NODE,
	SELECTING_NODE,
	PLAYING_MINIGAME,
	TRAVERSING,
	GAME_FINISHED,
}

var game_state = GameStates.INITIALISING

var word_utils = preload("res://utils/word_utils.tres") as WordUtils


func _ready() -> void:
	# Set up word utils
	randomize()
	word_utils.generate_all()

	# Connect relevant signals
	SignalBus.connect("website_completed", self, "_handle_website_completed")

	site_network.connect("Arrived", self, "_handle_website_arrived")

	# Set up firewall
	firewall.set_acceleration_multiplier(firewall_speed_multiplier)  # Used to speed up later (or stop movement for tutorial)
	firewall.set_x_position(firewall_start_pos)

	# Get first website
	player_camera.mover_node = mover_node

	print(word_utils.get_random_website())

# Signal callbacks
func _handle_website_completed(website_id: int, score: int) -> void:
	curr_score += score
	game_ui.set_score(curr_score)


func _handle_website_arrived(visited: bool, addresses: Array) -> void:
	print(addresses)
