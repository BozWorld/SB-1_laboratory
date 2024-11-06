extends CharacterBody3D

@export var anim_player : AnimationPlayer
@export var anim_tree : AnimationTree
var anim_state_travel
@export var camera:Camera3D
@export var springarm:SpringArm3D
@export var attack:Area3D
@export var facing:Node3D
@export var meshplayer : Node3D
@export var ref: Node3D
@export var direc_move : MeshInstance3D
@export var courbe_dodge :Curve
@export var index_courbe_dodge : int

@export var invulnerable : bool
@export var health : float 
@export var vie_ui : ProgressBar

@export var freezeframe : Timer
@export var floattimer: Timer
@export var gravity : float

@export var jumpbar : ProgressBar

@export var particle : GPUParticles3D
var jump_boost : float
var hit_boost : float
var hit : bool = false

var locked_on : bool = false
var object_locked : Node3D = null

var incr_cam_rotation = 0.0
var cam_velocity = 0.0
var dir_move = Vector3.ZERO
var direction  = Vector3.ZERO

var magie_de_l_angle = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	print(event)
	if event.is_action_pressed("attaque_devant"):
		ref.rotation.y = magie_de_l_angle * -1  
		ref.rotate_y(deg_to_rad(-90))
		
		if anim_state_travel.get_current_node() == "attaque_1" :
			anim_state_travel.travel("attaque_2")
		elif anim_state_travel.get_current_node() == "attaque_2" :
			anim_state_travel.travel("attaque_3")
		else :
			anim_state_travel.travel("sword_in")
			anim_state_travel.travel("attaque_1")
			
		
	if event.is_action_released("camera_droite") or event.is_action_released("camera_gauche"):
		incr_cam_rotation = 0.0
	
	if event.is_action_pressed("camera_droite"):
		incr_cam_rotation = -0.04
	
	if event.is_action_pressed("camera_gauche"):
		incr_cam_rotation = 0.04
	
	if event.is_action_pressed("roll"):
		ref.rotation.y = magie_de_l_angle * -1  
		ref.rotate_y(deg_to_rad(-90))
		#anim_state_travel.travel("rolling")
		anim_state_travel.travel("dash_forward")
		#anim_player.play("rolling")

	if event.is_action_pressed("saut") and jumpbar.value == 1.0:
		jump_boost = 10.0
		jumpbar.value = 0.0
		var tween_jump = get_tree().create_tween()
		tween_jump.tween_property(self,"jump_boost",0.0,0.4)
		launch_floattimer()

	if event.is_action_pressed("lock_on"):
		var cam_tween = get_tree().create_tween()
		
		if object_locked != null and !locked_on:
			locked_on = true
			cam_tween.tween_property(springarm,"spring_length",4.0,0.2)
		elif locked_on:
			camera.rotation.x = deg_to_rad(-39.1)
			camera.rotation.y = 0.0
			cam_tween.tween_property(springarm,"spring_length",5.0,0.2)
			locked_on = false

		
func _ready() -> void:
	DamageHandler.joueureuse = self
	invulnerable = false
	anim_state_travel = anim_tree["parameters/Player_state_machine/playback"]

func _process(delta: float) -> void:
	var vec_cam = camera.global_position - global_position
	#print(vec_cam)
	facing.position = Vector3(-vec_cam.x, position.y, -vec_cam.z)
	if incr_cam_rotation == 0.0:
		cam_velocity = cam_velocity / 1.05

	else :
		cam_velocity = cam_velocity + incr_cam_rotation
	cam_velocity = clampf(cam_velocity,-2.0,2.0)
	if locked_on:
		camera.look_at(object_locked.global_position)
		var cam_bien = self.global_position - object_locked.global_position
		var cam_magie = atan2(cam_bien.normalized().z,cam_bien.normalized().x)
		facing.position = cam_bien.normalized()
		springarm.rotation.y = cam_magie * -1.0
		springarm.rotate_y(deg_to_rad(90.0))

		
	springarm.rotate_y(deg_to_rad(cam_velocity))
	#attack.look_at(self.global_position)
	meshplayer.look_at(direc_move.global_position)
	#print(Plane(meshplayer.basis.z, direc_move.position,Vector3.ZERO).normal)

	if anim_state_travel.get_current_node() == "dash_forward":
		velocity = direction * 12.0 * courbe_dodge.get_point_position(index_courbe_dodge).y
		#print(courbe_dodge.get_point_position(index_courbe))
		#print(courbe_dodge.point_count)
	else :
		deplacement()
		velocity.y += gravity + 3.0 * (jump_boost + hit_boost)

	if is_on_floor():
		hit = false
	else :
		hit = true
	move_and_slide()

	if direction != Vector3.ZERO:
		direc_move.position = direction
	var coubeh = direc_move.position.normalized()
	#print(Vector3.ZERO.angle_to(direc_move.position.normalized()))
	#print(rad_to_deg(ref.rotation.y))
	magie_de_l_angle = atan2(coubeh.z,coubeh.x)
	#meshplayer.basis = meshplayer.basis.rotated(Vector3.UP,magie_de_l_angle)


func deplacement():
	var dir = Input.get_vector("gauche","droite","avant","arriere")
	dir_move = Vector3(dir.x,0,dir.y).rotated(Vector3.UP,springarm.rotation.y)
	if dir_move != Vector3.ZERO:
		direction = Vector3(dir_move.x, 0.0, dir_move.z )
	velocity =+ dir_move * 10


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("ça touche !", body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("ça vesqui !")

func _take_damage(ouch = 0.0):
	if !invulnerable:
		var tween = get_tree().create_tween()
		health -= ouch
		tween.tween_property(vie_ui,"value",health,0.4)
	

func _on_epai_body_body_entered(body: Node3D) -> void:
	pass


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_state_travel.get_current_node())


func _on_freeze_frame_timeout() -> void:
	get_tree().paused = false
	launch_floattimer()
	

func launch_floattimer():
	if floattimer.time_left == 0.0:
		gravity = -0.5
		floattimer.start()
func _on_float_timer_timeout() -> void:
	var tween_floating = get_tree().create_tween()
	tween_floating.tween_property(self,"gravity",-7.0,1.0)

func attaque() -> void:
	print("ATTAAAAQUE")
	
	hit_boost += 5.0
	particle.restart()
	var tweeen = get_tree().create_tween()
	tweeen.tween_property(self,"hit_boost",0.0,0.4)
	
	get_tree().paused = true
	freezeframe.start()
	if jumpbar.value == 0.0:
			
		var tween_jump_bar = get_tree().create_tween()
		tween_jump_bar.tween_property(jumpbar,"value",1.0,0.5)
		
func _on_epai_body_area_entered(area: Area3D) -> void:
	attaque()

func new_locked_target(object : Node3D):
	object_locked = object
	print(object_locked, "T'ES GRAND")
