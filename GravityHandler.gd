extends RefCounted
class_name GravityHandler


var energy_loss:= 0.0001
var linear_strength:= 50.0
var angular_strength:= 0.01

var speed_to_glide := 30.0
var inv_stg := 1.0/speed_to_glide

var gravity:= Vector3.ZERO
var gravity_mag:= 0.0
var gravity_dir:= Vector3.ZERO
#var last_forward := Vector3.FORWARD

var linear_force:= Vector3.ZERO
var angular_force:= 0.0


func setup(config : FlightConfiguration):
	energy_loss = config.energy_loss
	linear_strength = config.linear_strength
	angular_strength = config.angular_strength
	speed_to_glide = config.speed_to_glide
	inv_stg = 1.0/speed_to_glide
	
	gravity = Vector3.ZERO
	gravity_mag = 0.0
	gravity_dir = Vector3.ZERO
	#last_forward = Vector3.FORWARD

func set_gravity_magnitude(mag: float):
	gravity_mag = mag
	gravity = gravity_dir * gravity_mag

func set_gravity_direction(dir: Vector3):
	gravity_dir = dir.normalized()
	gravity = gravity_dir * gravity_mag

func _get_angular_force(forward_vector: Vector3, horizontal_speed: float, x_rota: float) -> float:
	var upward := 1.0 + forward_vector.y
	
	if horizontal_speed > 1.0:
		angular_force = angular_strength * (upward + 2.0/horizontal_speed)
	else: angular_force = angular_strength * (upward + 2.0)
	
	if abs(x_rota) > PI*0.5:
		angular_force = -angular_force
	
	#var _upward := 1.0-absf(forward_vector.y)
	#print(speed_to_glide)
	#print(speed)
	#if speed < speed_to_glide * 2.0 :
		#_upward =  (1.0 + forward_vector.y) * (speed_to_glide * 2.0 - speed) 
	#angular_force = 0.0
	#print(_upward)
	#if _upward >= 0.05:
		#angular_force = angular_strength * _upward
	return angular_force

func _get_linear_force(delta: float, forward_vector: Vector3, speed_mag: float, up_speed: float) -> Vector3:
	# Comme la gravité est pas encore incrémentée dans le process, on ajoute la dernière pour simuler
	speed_mag += linear_strength
	up_speed += gravity.y
	
	gravity_mag -= gravity_mag * energy_loss

	
	if speed_mag < speed_to_glide:
		gravity_dir = Vector3.DOWN.slerp(forward_vector, speed_mag * inv_stg)
	else:
		gravity_dir = forward_vector
	
	var planar_factor := absf(forward_vector.y)
	
	# Plus l'avion est horizontal, plus ses ailes négligent l'acceleration de la gravité
	gravity_mag += linear_strength * planar_factor
	
	
	# Si le moteur de l'avion le pousse vers le haut il néglige la velocité de gravité
	if up_speed > 0.0:
		gravity_mag -= clampf(up_speed * up_speed * 0.0001, 0.0, gravity_mag)
	
	#print(gravity_mag)
	
	gravity = gravity_mag * gravity_dir
	
	
	#print("Gravite : " + str(gravity))
	
	linear_force = gravity * delta
	return linear_force

func get_debug_string() -> String:
	var debug_text:= ""
	debug_text += "Gravité Linéaire: %.1v" % linear_force + "\n"
	debug_text += "Gravité Angulaire: %.3f" % angular_force
	return debug_text
