extends Control

export (BaseMinigame.MinigameType) var minigame_type
export (int) var max_data := 200
export (int) var decay_score := 1 

onready var prompt_text = get_node("%prompt_text")
onready var start_minigame_button = get_node("%start_minigame_button")
onready var minigame_container = get_node("%minigame_container")
onready var data_available_label = get_node("%data_available")
onready var data_timer_slider = get_node("%data_timer")

const prompt_texts = {
	BaseMinigame.MinigameType.ANAGRAM: "Unscramble this!",
	BaseMinigame.MinigameType.GRID: "Find the word!",
	BaseMinigame.MinigameType.HACK: "Type anything quickly!",
	BaseMinigame.MinigameType.PROMPT: "Type these words!"
}

var loaded_minigame: PackedScene
var minigame_started := false
var website_id: int  # TODO: Check what Yuri calls this

# Set up time decay
var loop_timer = Timer.new()
var current_data: int


func _ready() -> void:
	prompt_text = prompt_texts[minigame_type]
	start_minigame_button.connect("button_up", self, "_start_minigame") 

	loaded_minigame = BaseMinigame.minigame_lookup[minigame_type].instance()

	# Handle decay
	current_data = max_data
	loop_timer.set_wait_time(0.5)
	loop_timer.connect("timeout", self, "_decay_time")


func _start_minigame() -> void:
	start_minigame_button.hide()
	minigame_container.add_child(loaded_minigame)

	loaded_minigame.connect("minigame_complete", self, "_end_minigame")
	
	loaded_minigame.start_minigame()
	minigame_started = true


func _end_minigame() -> void:
	SignalBus.emit_signal("website_completed", website_id, current_data)
	hide()
	queue_free()


func _decay_time():
	current_data -= decay_score
	if current_data < max_data / 2:
		current_data = max_data / 2

	data_available_label = "%i".format(current_data)
	data_timer_slider.value = 200 * ((current_data / max_data) - 0.5)  # This maps the max_data/2 - max_data range to 0 - 100
	