extends RefCounted
class_name InputHandler

func get_input_data(delta: float, _current_speed: float, _group: bool) -> InputData:
    var data = InputData.new()
    data.throttle_change = _get_throttle_change(delta)
    data.turn_input = Input.get_axis("roll_right","roll_left")
    data.pitch_input = Input.get_axis("pitch_down","pitch_up")
    return data


func _get_throttle_change(delta: float) -> float:
    var throttle_change = 0.0
    var throttle_delta = 35.0

    if Input.is_action_pressed("throttle_up"):
        throttle_change = throttle_delta * delta
    elif Input.is_action_pressed("throttle_down"):
        throttle_change = -throttle_delta * delta

    return throttle_change