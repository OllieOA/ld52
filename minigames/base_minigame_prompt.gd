extends Control

export (BaseMinigame.MinigameType) var minigame_type
export (bool) var random_minigame = false
export (int) var max_data := 200
export (int) var decay_score := 1

onready var prompt_text = get_node("%prompt_text")
onready var start_minigame_button = get_node("%start_minigame_button")
onready var minigame_container = get_node("%minigame_container")
onready var data_timer_slider = get_node("%data_timer")
onready var data_available_label = get_node("%data_available")

const prompt_texts = {
	BaseMinigame.MinigameType.ANAGRAM: "Unscramble this!",
	# BaseMinigame.MinigameType.GRID: "Find the word!",
	# BaseMinigame.MinigameType.HACK: "Type anything quickly!",
	# BaseMinigame.MinigameType.PROMPT: "Type these words!",
	BaseMinigame.MinigameType.CAPITALS: "Find the word!",
	# BaseMinigame.MinigameType.HANGMAN: "Play hangman!",
	BaseMinigame.MinigameType.ALPHABET: "Type the alphabet!",
	# BaseMinigame.MinigameType.NUMBERS: "Type out the numbers!",
	# BaseMinigame.MinigameType.LONGEST: "Type the longest word!",
	# BaseMinigame.MinigameType.SHORTEST: "Type the shortest word!"
}

var minigame_lookup = {
	BaseMinigame.MinigameType.ANAGRAM: preload("res://minigames/anagram.tscn"),
	# BaseMinigame.MinigameType.GRID: preload("res://minigames/grid.tscn"),
	# BaseMinigame.MinigameType.HACK: preload("res://minigames/hack.tscn"),
	# BaseMinigame.MinigameType.PROMPT: preload("res://minigames/prompt.tscn"),
	BaseMinigame.MinigameType.CAPITALS: preload("res://minigames/capitals.tscn"),
	# BaseMinigame.MinigameType.HANGMAN: preload("res://minigames/hangman.tscn"),
	BaseMinigame.MinigameType.ALPHABET: preload("res://minigames/alphabet.tscn"),
	# BaseMinigame.MinigameType.NUMBERS: preload("res://minigames/numbers.tscn"),
	# BaseMinigame.MinigameType.LONGEST: preload("res://minigames/longest.tscn"),
	# BaseMinigame.MinigameType.SHORTEST: preload("res://minigames/shortest.tscn")
}

var loaded_minigame: Panel
var minigame_started := false
var website_id: int  # TODO: Check what Yuri calls this

# Set up time decay
var loop_timer = Timer.new()


func _ready() -> void:
	randomize()
	if random_minigame:
		minigame_type = BaseMinigame.MinigameType.keys()[randi() % BaseMinigame.MinigameType.size()]
	prompt_text.text = prompt_texts[minigame_type]
	start_minigame_button.connect("button_up", self, "_start_minigame") 

	loaded_minigame = minigame_lookup[minigame_type].instance()

	# Handle decay
	data_timer_slider.max_value = max_data
	data_timer_slider.min_value = max_data / 2
	data_timer_slider.value = max_data
	data_available_label.text = str(data_timer_slider.value)
	loop_timer.set_wait_time(0.2)
	loop_timer.connect("timeout", self, "_decay_time")
	add_child(loop_timer)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_minigame") and not minigame_started:
		_start_minigame()

func _start_minigame() -> void:
	start_minigame_button.hide()
	minigame_container.show()
	minigame_container.add_child(loaded_minigame)

	var _na = loaded_minigame.connect("minigame_complete", self, "_end_minigame")
	
	loaded_minigame.start_minigame()
	minigame_started = true
	loop_timer.start()


func _end_minigame() -> void:
	loop_timer.stop()
	SignalBus.emit_signal("website_completed", website_id, data_timer_slider)
	yield(get_tree().create_timer(0.5), "timeout")  # TODO: Replace with a sound/animation
	queue_free()


func _decay_time():
	data_timer_slider.value = data_timer_slider.value - decay_score
	data_available_label.text = str(data_timer_slider.value)
	
