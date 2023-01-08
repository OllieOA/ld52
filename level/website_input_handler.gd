extends Node2D

# This script will handle taking input from the player

signal website_str_updated(key_not_valid)

var word_utils = preload("res://utils/word_utils.tres")
var website_interface_active = true
var keys_pressed := {}  # TODO: Wrap this up with the event code one
var website_str := ""
var site_network
var possible_matches := []

func _ready() -> void:
	connect("website_str_updated", self, "_handle_website_str_updated")
	for each_scancode in word_utils.valid_scancodes:
		keys_pressed[each_scancode] = false


func _unhandled_input(event: InputEvent) -> void:
	if not website_interface_active:
		return
	
	if event.is_action_pressed("backspace_word"):
		website_str = website_str.substr(0, len(website_str) - 1)
		emit_signal("website_str_updated", false)
	elif event is InputEventKey:
		if event.scancode in word_utils.valid_scancodes:
			if not keys_pressed[event.scancode]:  # Check if currently pressed - prevents double keys
				keys_pressed[event.scancode] = true
				var key_typed = ""
				key_typed = OS.get_scancode_string(event.scancode)
				website_str += key_typed
				emit_signal("website_str_updated", key_typed == "")


func connect_network(site_network) -> void:
	site_network = site_network
	site_network.connect("Arrived", self, "_handle_arrived")


func _handle_website_str_updated(key_not_valid) -> void:
	if len(website_str) > word_utils.MAX_URL_LENGTH + 7:  # +7 for max possible suffix
		website_str = website_str.substr(0, len(website_str) - 1)  # Chip off
	
	# If its a unique url, emit as such, otherwise just update
	var matched_strs = []
	for possible_match in possible_matches:
		if possible_match.substr(0, len(website_str) + 1) == website_str:
			matched_strs.append(possible_match)

	if len(matched_strs) == 1:
		SignalBus.emit_signal("unique_match_found", matched_strs[0])
	elif len(matched_strs) == 0:
		SignalBus.emit_signal("no_str_matched")
	else:
		SignalBus.emit_signal("website_str_confirmed", website_str)  # All error handling done, now move to match


func _handle_arrived(_visited: bool, connected: Array) -> void:
	possible_matches = connected