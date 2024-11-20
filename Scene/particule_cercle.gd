extends Node2D
class_name ParticuleCercle

var rayon : float = 1.0
var couleur : Color = Color(0.0,0.0,0.0)
var epaisseur : float = 4.20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rayon += delta*100 + 5*(1/rayon)
	epaisseur -= delta*0.8
	if rayon > 50 :
		modulate.a -= delta*0.3
	queue_redraw()

func _draw():
	draw_circle(Vector2(0,0),rayon,couleur,false,epaisseur)
