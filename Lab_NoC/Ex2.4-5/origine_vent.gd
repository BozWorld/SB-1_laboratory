extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var deplacement : Vector3
	deplacement.z = Input.get_axis("avant","arriere")
	deplacement.x = Input.get_axis("gauche","droite")
	deplacement.y = Input.get_axis("bas","haut")
	
	position += deplacement

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("coupDeVent"):
		get_tree().call_group("Balle","_coup_de_vent",position)
