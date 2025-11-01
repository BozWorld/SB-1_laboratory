extends RefCounted
class_name GravityHandler


var energy_loss:= 0.1
var linear_strength:= 4.4
var angular_strength:= 0.01
var planar_factor:= 1.0

var gravity:= Vector3.ZERO
var gravity_mag:= 0.0
var gravity_dir:= Vector3.ZERO
var last_forward := Vector3.FORWARD

func setup(_energy_loss:= 0.05, _linear_strength:= 9.0, _angular_strength:= 0.01, _planar_factor:= 1.0):
	energy_loss = _energy_loss
	linear_strength = _linear_strength
	angular_strength = _angular_strength
	planar_factor = _planar_factor
	
	gravity = Vector3.ZERO
	gravity_mag = 0.0
	gravity_dir = Vector3.ZERO
	last_forward = Vector3.FORWARD

func set_gravity_magnitude(mag: float):
	gravity_mag = mag
	gravity = gravity_dir * gravity_mag

func set_gravity_direction(dir: Vector3):
	gravity_dir = dir.normalized()
	gravity = gravity_dir * gravity_mag

func _get_angular_force(forward_vector: Vector3) -> float:
	var _upward = forward_vector.distance_to(Vector3.DOWN)
	var angular_force := 0.0
	if _upward >= 0.05:
		angular_force = angular_strength * _upward
	return angular_force

func _get_linear_force(forward_vector: Vector3) -> Vector3:
	gravity -= gravity * energy_loss
	if last_forward != forward_vector:
		var difference = forward_vector - last_forward
		set_gravity_direction(gravity_dir + difference * planar_factor)
	last_forward = forward_vector
	
	var _v_inclinaison = forward_vector.distance_to(Vector3.FORWARD)
	print("Downward : " + str(_v_inclinaison))
	print("Forward : " + str(forward_vector))
	if _v_inclinaison >= 0.01:
		gravity -= Vector3(0,linear_strength * _v_inclinaison, 0)
		print("Gravity force added : " + str(linear_strength * _v_inclinaison))
	
	gravity_dir = gravity.normalized()
	gravity_mag = gravity.length()
	print("Gravity force applied : " + str(gravity))
	return gravity
