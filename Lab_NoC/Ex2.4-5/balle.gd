extends NoCObjet

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh.material.albedo_color = Color(randi_range(0,255),randi_range(0,255),randi_range(0,255))
	position = Vector3(randf_range(-10,10),randf_range(-10,10),randf_range(-10,10))

func check_collision():
	if position.x >= parent.taille or position.x <= -parent.taille :
			velocite.x = -velocite.x
	if position.y >= parent.taille or position.y <= -parent.taille :
			velocite.y = -velocite.y
	if position.z >= parent.taille or position.z <= -parent.taille :
			velocite.z = -velocite.z

func _coup_de_vent(origine_vent : Vector3):
	var vent = position - origine_vent
	vent = vent.normalized()
	appliquer_force(vent)



func _frottement():
	velocite *= 0.99

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance_centre = (Vector3(0,0,0)-position)
	
	_frottement()
	check_collision()
	bouger()
	
