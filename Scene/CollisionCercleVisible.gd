extends CollisionShape2D
class_name CollisionCercleVisible

var rayon := 0.0

var finie = false

var opacite := 0.0

func _ready() -> void:
	shape = CircleShape2D.new()
	shape.radius = 0
	modulate.a = 0

func _draw() -> void:
	draw_circle(Vector2(0,0),rayon,Color(1.0,1.0,1.0))
	draw_circle(Vector2(0,0),rayon,Color(0.0,0.0,0.0), false, 4.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !finie :
		if rayon < 240.0 :
			rayon += delta * 50 + rayon*0.01
		
		if modulate.a < 0.3 :
			modulate.a += delta*0.03
		
		shape.radius = rayon
		
	else :
		modulate.a -= delta*0.5
	
	
	
	
	queue_redraw()
