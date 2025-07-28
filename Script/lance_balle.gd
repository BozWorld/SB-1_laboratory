extends Node3D

var scene_balle = preload("res://Scene/balle_rebondissante.tscn")
var charge := false
var charge_masse := 0.0


func _physics_process(delta: float) -> void:
	if charge :
		charge_masse += delta

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("coupDeVent"):
		charge = true
	elif Input.is_action_just_released("coupDeVent"):
		charge = false
		lancerBalle()

func lancerBalle():
	var inst_balle = scene_balle.instantiate()
	if charge_masse >= 0.25 :
		inst_balle.masse = charge_masse
		inst_balle.velocite = -global_transform.basis.z * (1.0 +(10.0 * charge_masse)) 
	else :
		inst_balle.masse = randf_range(0.2,10)
		inst_balle.velocite = Vector3(randf_range(-10.0,10.0), randf_range(-10.0,10.0), randf_range(-10.0,10.0))
	
	charge_masse = 0.0
	%Boite.add_child(inst_balle)
