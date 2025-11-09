extends RefCounted
class_name InputData

var throttle_change: float = 0.0
var turn_input: float = 0.0
var pitch_input: float = 0.0
var boost:= false

func _init(p_throttle_change: float = 0.0, p_turn_input: float = 0.0, p_pitch_input: float = 0.0, p_boost: bool = false):
	self.throttle_change = p_throttle_change
	self.turn_input = p_turn_input
	self.pitch_input = p_pitch_input
	self.boost = p_boost

func _to_string() -> String:
	return "InputData(throttle_change: %f, turn_input: %f, pitch_input: %f)" % [throttle_change, turn_input, pitch_input]
