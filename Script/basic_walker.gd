extends Node2D


var num = 0
var pos = Vector2(0, 0)
var trail_positions: Array[Vector2] = []
var rng = RandomNumberGenerator.new()


func _ready() -> void:
    var num = rng.randfn(320,60)
    print("num = ", num)
    var screen_size = get_viewport().get_visible_rect().size
    pos = screen_size / 2  # On utilise pos comme référence principale
    queue_redraw()
    
func _process(delta: float) -> void:
    var old_pos = pos
    step()  # Déplacement aléatoire
    if pos != old_pos:
        trail_positions.append(pos)
    queue_redraw()

func step():
    var r = randf_range(0,1)
    var r_mouse = randf_range(0, 1)

    if r_mouse < 0.5:
        if r_mouse < 0.25:
            if pos.x < get_viewport().get_mouse_position().x:
                pos.x += 1
            else:
                pos.x -= 1
        else:
            if pos.y < get_viewport().get_mouse_position().y:
                pos.y += 1
            else:
                pos.y -= 1
        return
    else:
        if (r < 0.4):
            pos.x += 1
        elif (r < 0.6):
            pos.x -= 1
        elif (r < 0.8):
            pos.y += 1
        else:
            pos.y -= 1

func random_print():
        # num = randf_range(0,1)
    # if num < 0.6:
    #     print("sing")
    # elif num < 0.7:
    #     print("dance")
    # elif num < 0.8:
    #     print("Sleep!")
    return

func _draw() -> void:
    # Trace continue
    for i in range(1, trail_positions.size()):
        draw_line(trail_positions[i - 1], trail_positions[i], Color.WHITE, 5.0)
    # Position actuelle
    draw_circle(pos, 10, Color.RED)