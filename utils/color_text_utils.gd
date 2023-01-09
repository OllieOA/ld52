class_name ColorTextUtils extends Resource

export (Color) var correct_position_color = Color("#639765")
export (Color) var incorrect_position_color = Color("#a65455")
export (Color) var active_position_color = Color("#4682b4")
export (Color) var neutral_color = Color("#acacac")
export (Color) var neutral_color_dark = Color("#121212")
export (Color) var inactive_color = Color("#444444")
export (Color) var active_website_color = Color("#21b0b0")
export (Color) var mover_color = Color("#0cf9f9")
export (Color) var visited_website_color = Color("#639765")
export (Color) var pending_website_color = Color("#acacac")
export (Color) var visited_link_color = Color("#528654")
export (Color) var unvisited_link_color = Color("#9b9b9b")


func set_bbcode_color_string(string: String, color: Color) -> String:
	# False for no alpha
	var bbcode_str = "[color=#" + color.to_html(false) + "]" + string + "[/color]"
	return bbcode_str