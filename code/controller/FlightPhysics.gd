extends RefCounted

class_name FlightPhysics

signal speed_updated(speed: float)
signal boom_triggered(intensity: float)

var config: FlightConfiguration
var forward_speed: float = 0.0
var target_speed: float = 0.0
var previous_speed: float = 0.0

# Variables pour l'effet de boom
var boom_speed_threshold: float = 30.0
var last_boom_time: float = 0.0
var boom_cooldown: float = 2.0

var boost := false
var boost_strength := 0.0
var boost_index := 0.0
var post_boost := false
var post_boost_index := 0.0

var brake_charge:= 0.0
var bcharge_index:= 0.000

func setup(flight_config: FlightConfiguration):
	config = flight_config

func update_physics(input_data: InputData, delta: float, grounded: bool, forward_vector: Vector3, hydravion: bool) -> PhysicsResult:
	previous_speed = forward_speed
	
	_update_boost(delta, input_data)
	_update_target_speed(input_data.throttle_change, delta, grounded)
	forward_speed = lerpf(forward_speed, target_speed, config.acceleration * delta)

		
	# Détection de l'effet de boom
	_check_boom_effect()

	var result = PhysicsResult.new()
	result.speed = forward_speed
	result.turn_input = _calculate_turn_input(input_data.turn_input, forward_speed)
	result.pitch_input = _calculate_pitch_input(input_data.pitch_input, forward_speed, grounded, hydravion)
	result.should_takeoff = _should_takeoff(forward_speed, grounded, forward_vector)
	result.takeoff_force = _calculate_takeoff_force(forward_speed)
	result.brake = brake_charge
	result.boost = boost
	
	speed_updated.emit(forward_speed)
	return result

func _update_boost(delta: float, input_data: InputData):
	if input_data.boost:
		
		if brake_charge:
			if !boost:
				boost = true
				boost_index = 0.0
				
			boost_strength = config.boost_grow.sample(boost_index) * config.boost_peak
			boost_index += delta * config.inv_boost_max_duration
			
			if boost_index > brake_charge:
				brake_charge = 0.0
				boost_index = 0.0
				boost_strength = 0.0
				boost = false	
		else :
			boost_index = 0.0
			boost_strength = 0.0
			boost = false	
	
	else :
		boost = false
		boost_strength = 0.0
		boost_index = 0.0
		if input_data.throttle_change < 0:
			brake_charge = config.boost_charge.sample_baked(bcharge_index)
			bcharge_index += delta
		elif brake_charge >= 0.0:
			brake_charge -= delta * config.boost_charge_loss
			bcharge_index -= delta
		elif input_data.throttle_change == 0:
			brake_charge = 0.0
			bcharge_index = 0.0
		
		
		
		
	
	

func _check_boom_effect():
	var current_time = Time.get_time_dict_from_system()["second"]
	
	# Vérifier si on franchit le seuil de vitesse et si le cooldown est écoulé
	if previous_speed < boom_speed_threshold and forward_speed >= boom_speed_threshold:
		if current_time - last_boom_time > boom_cooldown:
			var intensity = min(forward_speed / config.max_flight_speed, 1.0)
			boom_triggered.emit(intensity)
			last_boom_time = current_time
			print("BOOM déclenché! Vitesse: %.1f, Intensité: %.2f" % [forward_speed, intensity])

func _update_target_speed(throttle_change: float, delta: float, grounded: bool):
	#if throttle_change != 0.0:
		target_speed += throttle_change * config.throttle_delta * delta
		var max_limit = config.max_flight_speed 
		if grounded:
			max_limit = max(config.min_flight_speed * 1.5, 0.0)
		elif boost :
			max_limit += config.boost_peak
			target_speed += boost_strength * delta
			
			post_boost = true
		elif post_boost :
			max_limit += lerpf(config.boost_peak, 0.0, post_boost_index)
			post_boost_index += delta * config.inv_boost_momentum
			if post_boost_index >= 1.0 :
				post_boost_index = 0.0
				post_boost = false
		target_speed = clamp(target_speed, 0.0, max_limit)

func _calculate_turn_input(raw_input: float, speed: float) -> float:
	if speed < 2.0:
		return raw_input * 0.3
	return raw_input * config.turn_speed

func _calculate_pitch_input(raw_input: float, speed: float, grounded: bool, hydravion: bool) -> float:
	if grounded:
		if hydravion and raw_input > 0.0:
			if speed < 3.0:
				return raw_input * config.pitch_speed * 0.5
			return raw_input * config.pitch_speed
		return 0.0
	elif speed < 3.0:
		return raw_input * config.pitch_speed * 0.5
	return raw_input * config.pitch_speed

func _should_takeoff(speed: float, grounded: bool, forward_vector: Vector3) -> bool:
	return grounded and speed > config.min_flight_speed * 1.1 and forward_vector.y > 0.1

func _calculate_takeoff_force(speed: float) -> float:
	return 3.0 * (speed / config.min_flight_speed)

func get_debug_string() -> String:
	return "Vitesse: %.1f / %.1f" % [forward_speed, target_speed]
