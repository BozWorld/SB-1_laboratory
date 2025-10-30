extends RefCounted
class_name InputHandler

var index_boost := 0.0
var seuil_boost := 0.6
var cd := 2.0
var index_cd := 0.0

var inv_seuil = 1.0/seuil_boost

func get_input_data(delta: float, _current_speed: float, _group: bool) -> InputData:
	var data = InputData.new()
	data.throttle_change = _get_throttle_change(delta)
	data.turn_input = Input.get_axis("roll_right","roll_left")
	data.pitch_input = Input.get_axis("pitch_down","pitch_up")
	return data

func get_input_boost(delta: float):
	if index_cd >= cd :
		if Input.is_action_pressed("boost"):
			index_boost += delta
			if index_boost >= seuil_boost :
				index_boost = 0.0
				index_cd = 0.0
				return 1.0
		elif index_boost > 0.0 :
			index_boost -= delta
		else : 
			index_boost = 0.0
		
		return index_boost * inv_seuil
	else :
		index_cd += delta
		return 0.0

func _get_throttle_change(delta: float) -> float:
	var throttle_change = 0.0
	var throttle_delta = 35.0

	if Input.is_action_pressed("throttle_up"):
		throttle_change = throttle_delta * delta
	elif Input.is_action_pressed("throttle_down"):
		throttle_change = -throttle_delta * delta

	return throttle_change
