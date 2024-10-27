extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rot = Input.get_axis("left","right")
	if rot != 0:
		rotation.z += deg_to_rad(rot * 0.4)
	else :
		rotation.z = lerp(rotation.z,0.0,0.04)
	if Input.is_action_pressed("left"):
		rotation.z += deg_to_rad(-0.4)
	if Input.is_action_pressed("right"):
		rotation.z += deg_to_rad(0.4)
	rotation.z = clamp(rotation.z,deg_to_rad(-12),deg_to_rad(12))
	pass
