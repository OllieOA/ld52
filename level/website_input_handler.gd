extends Node2D

# This script will handle taking input from the player

signal website_str_updated(key_not_valid)

onready var good_type_sound = get_node("%good_type_sound")
onready var bad_type_sound = get_node("%bad_type_sound")

onready var level_reference = get_parent()

var word_utils = preload("res://utils/word_utils.tres")
var website_interface_active = true
var keys_pressed := {}  # TODO: Wrap this up with the event code one
var website_str := ""
var site_network
var possible_matches := []
var can_enter := true
var matched := false

var game_over = false

func _ready() -> void:
	var _na = connect("website_str_updated", self, "_handle_website_str_updated")
	_na = SignalBus.connect("website_completed", self, "_handle_website_minigame_completed")
	_na = SignalBus.connect("game_over", self, "_handle_game_over")
	for each_scancode in word_utils.valid_scancodes:
		keys_pressed[each_scancode] = false


func _unhandled_input(event: InputEvent) -> void:
	if not website_interface_active:
		return

	if game_over:
		return
	
	if event.is_action_pressed("backspace_word") and not matched:
		website_str = website_str.substr(0, len(website_str) - 1)
		emit_signal("website_str_updated", false)
		can_enter = true
	elif event is InputEventKey:
		if event.scancode in word_utils.valid_scancodes:
			if not keys_pressed[event.scancode]:  # Check if currently pressed - prevents double keys
				keys_pressed[event.scancode] = true
				var key_typed = ""

				if can_enter:
					if event.scancode in word_utils.special_scancodes:
						website_str += word_utils.SPECIAL_LOOKUP[event.scancode]
					else:  # Must be alpha
						key_typed = OS.get_scancode_string(event.scancode)
					website_str += key_typed.to_lower()
					emit_signal("website_str_updated", key_typed == "")

			elif not event.is_pressed():  # Allow the key to be pressed again
				keys_pressed[event.scancode] = false

			elif not can_enter:
				pass  # TODO: Handle entering when not allowed


func connect_network(site_network_ref) -> void:
	site_network = site_network_ref
	var _na = site_network.connect("Arrived", self, "_handle_arrived")
	possible_matches = site_network.CurrentSite.AvailableAddresses()


func _handle_website_str_updated(_key_not_valid) -> void:
	if len(website_str) > word_utils.MAX_URL_LENGTH + 7:  # +7 for max possible suffix
		website_str = website_str.substr(0, len(website_str) - 1)  # Chip off
	
	# If its a unique url, emit as such, otherwise just update
	var matched_strs = []
	for possible_match in possible_matches:
		if possible_match.substr(0, len(website_str)) == website_str:
			matched_strs.append(possible_match)

	if len(matched_strs) == 1:
		if matched_strs[0] == website_str:
			can_enter = false
			matched = true
			SignalBus.emit_signal("unique_match_found", matched_strs[0])
			level_reference.play_points_gained()
		else:
			SignalBus.emit_signal("website_str_confirmed", website_str)
			good_type_sound.play()
	elif len(matched_strs) == 0:
		can_enter = false  # Prevent enter, TODO: Make it clear why
		SignalBus.emit_signal("no_str_matched", website_str)
		bad_type_sound.play()
		get_parent().emit_signal("bad_key_level")
	else:
		# No full match yet but some available
		SignalBus.emit_signal("website_str_confirmed", website_str)  # All error handling done, now move to match
		good_type_sound.play()


func _handle_arrived(visited: bool, connected: Array) -> void:
	possible_matches = connected
	website_str = ""
	SignalBus.emit_signal("website_str_confirmed", website_str)
	if visited:
		can_enter = true
		matched = false


func _handle_website_minigame_completed(website_id: int, data_scraped: int) -> void:
	can_enter = true
	matched = false


func _handle_game_over() -> void:
	can_enter = false
	game_over = true
