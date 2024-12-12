extends StaticBody3D

var is_nooting = false
var is_poussing = false

var memoire_scale = 0.0

@export var son_1 : Resource
@export var son_2 : Resource
@export var son_3 : Resource

@onready var son = $NootPlayer

@onready var collision_bec_bizarre = $CollisionShape3D

@onready var grand_parent = $"../../../../.."

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("noot"):
		is_nooting = true
		son.stream = son_1
		son.play()
		
	if Input.is_action_just_released("noot"):
		is_nooting = false
		son.stream = son_3
		son.play()

func _physics_process(delta: float) -> void:
	if is_nooting :
		scale.z += delta*8
	else :
		if scale.z != 1.0 :
			memoire_scale = scale.z
			scale.z = 1.0


func bec_touche_mur(body: Node3D) -> void:
	is_poussing = true

func bec_touche_plus_mur(body: Node3D) -> void:
	is_poussing = false

func _nooting_process(delta):
	if is_poussing :
		var orientation_pousse = grand_parent.camera.global_rotation
		if orientation_pousse :
			grand_parent.appliquer_force_verticale(delta*300)


func _on_noot_player_finished() -> void:
	if son.stream == son_1:
		son.stream = son_2
		son.play()
	if son.stream == son_2:
		son.play()
