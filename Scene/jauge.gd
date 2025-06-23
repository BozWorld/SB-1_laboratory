extends Node2D


var randomCounts = []

var total = 20

func _ready():
  for i in range(total):
    randomCounts.append(0)

func _process(delta):
    var _index = int(randf_range(0, randomCounts.size()))
    randomCounts[_index] += 1
    queue_redraw()

func _draw():
    var screen_size = get_viewport_rect().size
    var width = screen_size.x
    var height = screen_size.y
    
    # Équivalent de stroke(0) et fill(127)
    var fill_color = Color(0.5, 0.5, 0.5)  # Gris (127/255 ≈ 0.5)
    var stroke_color = Color.BLACK
    
    var w = width / randomCounts.size()
    
    for x in range(randomCounts.size()):
        var rect_x = x * w
        var rect_y = height - randomCounts[x]
        var rect_width = w - 1
        var rect_height = randomCounts[x]
        
        # Dessiner le rectangle rempli
        var rect = Rect2(rect_x, rect_y, rect_width, rect_height)
        draw_rect(rect, fill_color)
        
        # Dessiner le contour (optionnel)
        draw_rect(rect, stroke_color, false, 1.0)