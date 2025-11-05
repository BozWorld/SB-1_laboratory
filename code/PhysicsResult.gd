extends RefCounted
class_name PhysicsResult


var speed: float = 0.0
var turn_input: float = 0.0
var pitch_input: float = 0.0
var should_takeoff: bool = false
var takeoff_force: float = 0.0
var brake:= 0.0
var boost

func _init(spd: float = 0.0, turn: float = 0.0, pitch: float = 0.0, takeoff: bool = false, takeoff_f: float = 0.0, _brake:= 0.0, _boost := false):
	speed = spd
	turn_input = turn
	pitch_input = pitch
	should_takeoff = takeoff
	takeoff_force = takeoff_f
	brake = _brake
	boost = _boost

func _to_string() -> String:
	return "PhysicsResult(speed: %.1f, turn:%.2f, pitch: %.2f, takeoff: %s)" % [speed, turn_input, pitch_input, should_takeoff]
