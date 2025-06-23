extends Sprite2D

func _ready():
    var screen_size = get_viewport().get_visible_rect().size
    var width = screen_size.x
    var height = screen_size.y
    position = Vector2(width/2, height/2)
    print("Screen size: ", screen_size)
    print("Position: ", position)