extends Node2D
class_name PointeConstelleur

var pointe = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		pointe = event.position - get_viewport().get_visible_rect().size/2
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0,0),pointe,Color(255,255,255,130), 3)
