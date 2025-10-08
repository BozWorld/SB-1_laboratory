extends RefCounted
class_name InputData

var throttle_change: float = 0.0
var turn_input: float = 0.0
var pitch_input: float = 0.0


func _init(throttle_change: float = 0.0, turn_input: float = 0.0, pitch_input: float = 0.0):
    self.throttle_change = throttle_change
    self.turn_input = turn_input
    self.pitch_input = pitch_input

func _to_string() -> String:
    return "InputData(throttle_change: %f, turn_input: %f, pitch_input: %f)" % [throttle_change, turn_input, pitch_input]