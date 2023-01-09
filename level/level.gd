class_name Level extends Node2D


# Handle signals
signal website_prompt_enabled
signal website_prompt_disabled
signal WebsitePromptFinished
signal bad_key_level
signal points_gained(points_gained)

# Get relevant nodes
onready var game_ui = get_node("%game_ui")
onready var site_network = get_node("%site_network")
onready var mover_node = site_network.get_node("Mover")  # under the site network
onready var player_camera = get_node("%player_camera")
onready var firewall = get_node("%firewall")
onready var website_input_handler = get_node("%website_input_handler")
onready var minigame_layer = get_node("%minigame_layer")
onready var points_gained_sound = get_node("%points_gained_sound")
onready var game_over_handler = get_node("%game_over_handler")

# Handle minigames
const minigame_scene = preload("res://minigames/base_minigame_prompt.tscn")

# Handle firewall
var firewall_speed_multiplier := 1.0
const firewall_start_pos := -300
var firewall_position := Vector2.ZERO
var mover_position := Vector2.ZERO

# Handle score
const _SCORE_TRACKER_PATH = "user://score_tracker.tres"
var score_tracker: Resource
var curr_score := 0
var level_arrive_score := 300
var num_websites_visited := 0
var num_games_completed := 0
const base_website_data_available := 400

var best_run_score := 0
var best_run_visited := 0

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
	# Connect relevant signals
	var _na = SignalBus.connect("website_completed", self, "_handle_website_completed")
	_na = SignalBus.connect("unique_match_found", self, "_handle_traverse_to")
	_na = connect("points_gained", self, "play_points_gained")
	_na = SignalBus.connect("game_over", self, "_handle_game_over")

	_na = site_network.connect("Arrived", self, "_handle_website_arrived")
	site_network.ShowAdjacentNodes()  # Initialise
	# site_network.connect
	website_input_handler.connect_network(site_network)

	# Set up firewall
	firewall.set_acceleration_multiplier(firewall_speed_multiplier)  # Used to speed up later (or stop movement for tutorial)
	firewall.set_x_position(firewall_start_pos)

	# Get first website
	player_camera.mover_node = mover_node

	# Handle scoring

	if File.new().file_exists(_SCORE_TRACKER_PATH):
		score_tracker = ResourceLoader.load(_SCORE_TRACKER_PATH)
	else:
		score_tracker = ScoreTracker.new()


func _process(delta: float) -> void:
	firewall_position = firewall.global_position
	mover_position = mover_node.global_position

	game_ui.set_proximity(abs(mover_position.x - firewall_position.x))

	if firewall_position.x >= mover_position.x:
		SignalBus.emit_signal("game_over")


# Signal callbacks
func _handle_website_completed(website_id: int, score: int) -> void:
	curr_score += score
	game_ui.set_score(curr_score)
	emit_signal("WebsitePromptFinished")  # For C# hook in
	emit_signal("points_gained")

	num_games_completed += 1
	level_arrive_score = 300 + 10 * num_games_completed


func _handle_website_arrived(visited: bool, addresses: Array) -> void:
	if not visited:

		num_websites_visited += 1
		# Spawn a minigame
		var new_minigame = minigame_scene.instance()
		new_minigame.random_minigame = true
		minigame_layer.add_child(new_minigame)

		curr_score += level_arrive_score
		game_ui.set_score(curr_score)

		SignalBus.emit_signal("triggered_minigame_prompt")


func _handle_traverse_to(address: String) -> void:
	site_network.emit_signal("Goto", address)


func play_points_gained() -> void:
	points_gained_sound.play()


func _handle_game_over() -> void:
	score_tracker.update_best_scores(curr_score, num_websites_visited)
	var result = ResourceSaver.save(_SCORE_TRACKER_PATH, score_tracker)
	assert(result == OK)

	game_over_handler.start_game_over_sequence(curr_score, num_websites_visited, score_tracker.best_run_score, score_tracker.best_visited_score)
