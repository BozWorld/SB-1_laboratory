extends NoCObjet


func _ready() -> void:
	mesh.material.albedo_color = Color(randi_range(0,255),randi_range(0,255),randi_range(0,255))
	position = Vector3(randf_range(-10,10),randf_range(-10,10),randf_range(-10,10))
	velocite = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	masse = randf_range(0.1,5)

func _physics_process(delta: float) -> void:
	var distance_centre = (Vector3(0,0,0)-position)
	var attraction = distance_centre.normalized() * distance_centre.length() * delta
	appliquerForce(attraction)
	_bouger()
