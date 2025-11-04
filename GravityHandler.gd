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



func setup(_energy_loss:= 0.01, _linear_strength:= 24.0, _angular_strength:= 0.01, _speed_to_glide:= 30.0):
	energy_loss = _energy_loss
	linear_strength = _linear_strength
	angular_strength = _angular_strength
	speed_to_glide = _speed_to_glide
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

func _get_angular_force(forward_vector: Vector3) -> float:
	var _upward = 1.0-abs(forward_vector.y)
	var angular_force := 0.0
	if _upward >= 0.05:
		angular_force = angular_strength * _upward
	return angular_force

func _get_linear_force(forward_vector: Vector3, speed_mag: float) -> Vector3:
	gravity_mag -= gravity_mag * energy_loss
	
	
	speed_mag = clampf(speed_mag, 0.0, speed_to_glide)
	gravity_dir = Vector3.DOWN.slerp(forward_vector, speed_mag * inv_stg)
	
	var planar_factor := absf(forward_vector.y)
	var motor_factor := 1.0 - speed_mag * inv_stg
	
	# Plus l'avion est horizontal, plus ses ailes négligent l'acceleration de la gravité
	gravity_mag += linear_strength * (planar_factor + motor_factor)
	
	# Si le moteur de l'avion le pousse vers le haut il néglige petit à petit la force de gravité
	if forward_vector.y > 0.0:
		gravity_mag *= clampf(1.0-planar_factor + motor_factor, 0.0, 1.0)
	
	gravity = gravity_mag * gravity_dir
	
	
	print("Gravite : " + str(gravity))
	
	return gravity
	
	
	
	
	
	
	
	
	#if last_forward != forward_vector:
		#var difference = forward_vector - last_forward
		#set_gravity_direction(gravity_dir + difference * planar_factor)
	#last_forward = forward_vector
	#
	#var _v_inclinaison = abs(forward_vector.y)
	#print("Downward : " + str(_v_inclinaison))
	#print("Forward : " + str(forward_vector))
	#if _v_inclinaison >= 0.01:
		#gravity -= Vector3(0,linear_strength * _v_inclinaison, 0)
		#print("Gravity force added : " + str(linear_strength * _v_inclinaison))
	#
	#gravity_dir = gravity.normalized()
	#gravity_mag = gravity.length()
	#print("Gravity force applied : " + str(gravity))
	#return gravity
