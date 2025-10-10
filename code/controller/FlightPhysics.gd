extends RefCounted

class_name FlightPhysics

signal speed_updated(speed: float)


var config: FlightConfiguration
var forward_speed: float = 0.0
var target_speed: float = 0.0
var previous_speed: float = 0.0

func setup(flight_config: FlightConfiguration):
    config = flight_config

func update_physics(input_data: InputData, delta: float, grounded: bool) -> PhysicsResult:
    previous_speed = forward_speed

    _update_target_speed(input_data.throttle_change, grounded)
    forward_speed = lerpf(forward_speed, target_speed, config.acceleration * delta)


    var result = PhysicsResult.new()
    result.speed = forward_speed
    result.turn_input = _calculate_turn_input(input_data.turn_input, forward_speed)
    result.pitch_input = _calculate_pitch_input(input_data.pitch_input, forward_speed, grounded)
    result.should_takeoff = _should_takeoff(forward_speed, grounded)
    result.takeoff_force = _calculate_takeoff_force(forward_speed)
    speed_updated.emit(forward_speed)
    return result

func _update_target_speed(throttle_change: float, grounded: bool):
    if throttle_change != 0.0:
        target_speed += throttle_change
        var max_limit = config.max_flight_speed
        if grounded:
            max_limit = config.min_flight_speed * 1.5
        
        target_speed = clamp(target_speed, 0.0, max_limit)

func _calculate_turn_input(raw_input: float, speed: float) -> float:
    if speed < 2.0:
        return raw_input * 0.3
    return raw_input * config.turn_speed

func _calculate_pitch_input(raw_input: float, speed: float, grounded: bool) -> float:
    if grounded:
        return 0.0
    elif speed < 3.0:
        return raw_input * config.pitch_speed * 0.5
    return raw_input * config.pitch_speed

func _should_takeoff(speed: float, grounded: bool) -> bool:
    return grounded and speed > config.min_flight_speed * 1.1

func _calculate_takeoff_force(speed: float) -> float:
    return 3.0 * (speed / config.min_flight_speed)

func get_debug_string() -> String:
    return "Vitesse: %.1f / %.1f" % [forward_speed, target_speed]