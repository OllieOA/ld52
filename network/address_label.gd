extends RichTextLabel

const PX_PER_CHAR = 8

func _ready() -> void:
    # Only thing this needs to do is update its width when text is assigned
    get_parent().connect("LabelAssigned", self, "_update_width")


func _update_width() -> void:
    var num_chars = len(text)
    rect_size = Vector2(PX_PER_CHAR * num_chars + 6, rect_size.y)

    margin_left = rect_size.x / -2
    margin_right = rect_size.x / 2