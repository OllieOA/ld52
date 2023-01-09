extends RichTextLabel

const PX_PER_CHAR = 9

func _ready() -> void:
    # Only thing this needs to do is update its width when text is assigned
    var _na = get_parent().connect("LabelAssigned", self, "_update_width")


func _update_width() -> void:
    var new_size = PX_PER_CHAR * len(text) + 6
    rect_size = Vector2(new_size, rect_size.y)

    margin_left = new_size / -2
    margin_right = new_size / 2