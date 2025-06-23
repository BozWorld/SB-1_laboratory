extends Control


func _ready() -> void:
    size = get_viewport().get_visible_rect().size/2
    print("screen size = ", get_viewport().get_visible_rect().size)
    print("size = ", size)
    pass