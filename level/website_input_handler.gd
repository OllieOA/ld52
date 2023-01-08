extends Node2D

# This script will handle taking input from the player

signal website_str_updated(key_not_valid)

var word_utils = preload("res://utils/word_utils.tres")
var website_interface_active = true
var keys_pressed := {}  # TODO: Wrap this up with the event code one
var website_str := ""
var site_network
var possible_matches := []
var can_enter = true

func _ready() -> void:
	var _na = connect("website_str_updated", self, "_handle_website_str_updated")
	_na = site_network.connect("Arrived", self, "_handle_new_node")
	_na = SignalBus.connect("website_completed", self, "_handle_website_minigame_completed")
	for each_scancode in word_utils.valid_scancodes:
		keys_pressed[each_scancode] = false


func _unhandled_input(event: InputEvent) -> void:
	if not website_interface_active:
		return
	
	if event.is_action_pressed("backspace_word"):
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
	print("KEY TYPED: NEW STR: " + website_str)
	if len(website_str) > word_utils.MAX_URL_LENGTH + 7:  # +7 for max possible suffix
		website_str = website_str.substr(0, len(website_str) - 1)  # Chip off
	
	# If its a unique url, emit as such, otherwise just update
	var matched_strs = []
	print("POSSIBLE_MATCHES "+str(possible_matches))
	for possible_match in possible_matches:
		if possible_match.substr(0, len(website_str)) == website_str:
			matched_strs.append(possible_match)

	print("CURR_MATCHED " + str(matched_strs))

	if len(matched_strs) == 1:
		if matched_strs[0] == website_str:
			can_enter = false
			SignalBus.emit_signal("unique_match_found", matched_strs[0])
		else:
			SignalBus.emit_signal("website_str_confirmed", website_str)
	elif len(matched_strs) == 0:
		SignalBus.emit_signal("no_str_matched", website_str)
		can_enter = false  # Prevent enter, TODO: Make it clear why
	else:
		# No full match yet but some available
		SignalBus.emit_signal("website_str_confirmed", website_str)  # All error handling done, now move to match


func _handle_arrived(_visited: bool, connected: Array) -> void:
	possible_matches = connected
	website_str = ""
	SignalBus.emit_signal("website_str_confirmed", website_str)


func _handle_website_minigame_completed(website_id: int, data_scraped: int) -> void:
	can_enter = true