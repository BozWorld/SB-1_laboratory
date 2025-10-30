extends RefCounted
class_name Pid3D

var _p: float
var _i: float
var _d: float

var _precedente_diff: Vector3
var _integrale_diff: Vector3

func _init(p: float, i: float, d: float) -> void:
	_p = p
	_i = i
	_d = d

func actualiser(diff: Vector3, delta: float) -> Vector3:
	_integrale_diff += diff * delta
	var _derivee_diff = (diff - _precedente_diff) / delta
	_precedente_diff = diff
	return _p * diff + _i * _integrale_diff + _d * _derivee_diff
