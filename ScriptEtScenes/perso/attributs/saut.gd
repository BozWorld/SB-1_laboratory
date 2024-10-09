extends Attribut3D

var genoux_flechis := false

var flexion := 0.0
@export var max_flexion := 5.0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("saut"):
		genoux_flechis = true
		parent.scale.y = 0.8
		
	elif Input.is_action_just_released("saut"):
		var saut : Vector3
		if parent.is_on_floor() :
			saut.y = 20
		else :
			saut.y = 0
			
		saut.y += flexion * 10
		parent.apply_force(saut)
		
		genoux_flechis = false
		parent.scale.y = 1.0
		flexion = 0

func _physics_process(delta: float) -> void:
	if genoux_flechis and flexion < max_flexion :
		flexion += 1.0 * delta
		print("flexion : " + str(flexion))
