extends CanvasLayer

var level_reference: Node2D

onready var game_over_player = get_node("%game_over_player")
onready var typing_noise = get_node("%typing_noise")
onready var win_noise = get_node("%win_noise")
onready var number_tween = get_node("%score_counter")

onready var this_run_score_label = get_node("%this_score_text")
onready var this_run_visited_label = get_node("%this_websites_visited_text")
onready var best_run_score_label = get_node("%best_score_text")
onready var best_run_visited_label = get_node("%best_websites_visited_text")

var allow_skip := false
const SKIP_TIME := 10
var rng = RandomNumberGenerator.new()


var _this_run_score := 0
var _this_run_visited := 0
var _best_run_score := 0
var _best_run_visited := 0

var _target_this_run_score := 0
var _target_this_run_visited := 0
var _target_best_run_score := 0
var _target_best_run_visited := 0


func _ready() -> void:
	rng.randomize()
	level_reference = get_parent()
	var _na = game_over_player.connect("animation_finished", self, "_handle_animation_finished")


func _process(delta: float) -> void:
	_update_score(this_run_score_label, _this_run_score)
	_update_score(this_run_visited_label, _this_run_visited)
	_update_score(best_run_score_label, _best_run_score)
	_update_score(best_run_visited_label, _best_run_visited)


func _update_score(target_label: Label, target_value: int) -> void:
	var score_as_str = str(target_value)
		
	var i : int = score_as_str.length() - 3
	while i > 0:
		score_as_str = score_as_str.insert(i, ",")
		i = i - 3
			
	target_label.text = score_as_str


func start_game_over_sequence(this_run_score, this_run_visited, best_run_score, best_run_visited) -> void:
	game_over_player.play("game_over")
	show()

	_target_this_run_score = this_run_score
	_target_this_run_visited = this_run_visited
	_target_best_run_score = best_run_score
	_target_best_run_visited = best_run_visited


func play_typing_noise() -> void:
	typing_noise.pitch_scale = rng.randf_range(0.97, 1.03)
	typing_noise.play()


func _unhandled_input(event: InputEvent) -> void:
	if allow_skip and event.is_action_pressed("skip_gameover"):
		game_over_player.seek(SKIP_TIME)


func set_allow_skip() -> void:
	allow_skip = true


func run_score_tween() -> void:
	number_tween.interpolate_property(
		self, 
		"_this_run_score", 
		0, 
		_target_this_run_score,
		3.0,
		number_tween.TRANS_QUAD,
		number_tween.EASE_IN
		)

	number_tween.interpolate_property(
		self, 
		"_this_run_visited", 
		0, 
		_target_this_run_visited,
		3.0,
		number_tween.TRANS_QUAD,
		number_tween.EASE_IN
		)

	number_tween.interpolate_property(
		self, 
		"_best_run_score", 
		0, 
		_target_best_run_score,
		3.0,
		number_tween.TRANS_QUAD,
		number_tween.EASE_IN
		)

	number_tween.interpolate_property(
		self, 
		"_best_run_visited", 
		0, 
		_target_best_run_visited,
		3.0,
		number_tween.TRANS_QUAD,
		number_tween.EASE_IN
		)
	
	number_tween.start()


func _handle_animation_finished(_anim_name: String) -> void:
	game_over_player.stop()