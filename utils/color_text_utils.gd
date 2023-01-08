class_name ColorTextUtils extends Resource

# Some colours - TODO: Yuri to tweak
export (Color) var correct_position_color = Color("#639765")
export (Color) var incorrect_position_color = Color("#a65455")
export (Color) var active_position_color = Color("#4682b4")
export (Color) var neutral_color = Color("acacac")
export (Color) var inactive_color = Color("444444")


func set_bbcode_color_string(string: String, color: Color) -> String:
	# False for no alpha
	var bbcode_str = "[color=#" + color.to_html(false) + "]" + string + "[/color]"
	return bbcode_str