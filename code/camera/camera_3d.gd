extends Camera3D

@export var target_path : NodePath
@export var lerp_speed = 3.0
@export var lookahead = Vector3(0, 2, -6)  # où regarder
@export var offset = Vector3(0, 1.5, 6)    # position de la cam

var target : Node3D

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	if not target:
		return

	var desired_position = target.global_transform.origin + target.global_transform.basis * offset
	global_transform.origin = global_transform.origin.lerp(desired_position, lerp_speed * delta)

	var look_target = target.global_transform.origin + target.global_transform.basis * lookahead
	look_at(look_target, Vector3.UP)
