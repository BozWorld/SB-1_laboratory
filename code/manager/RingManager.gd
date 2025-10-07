extends Node
class_name RingManager

signal ring_passed(ring_index: int)
signal all_rings_completed

var _rings: Array[Node3D] = []
var _current_ring_index: int = 0

func setup_rings(rings: Array[Node3D]):
	_rings = rings
	_current_ring_index = 0

	for i in _rings.size():
		print("Setting up ring: ", i)
		print("Ring path: ", _rings[i])
		var ring = _rings[i]
		print("Ring node: ", ring)
		ring.ring_order = i 

		if i == 0:
			ring.set_active(true)
		else:
			ring.set_active(false)

func on_ring_passed(ring_order: int):
	if ring_order == _current_ring_index:
		_rings[_current_ring_index].set_active(false)
		_current_ring_index += 1
		ring_passed.emit(ring_order)
		
		if _current_ring_index < _rings.size():
			_rings[_current_ring_index].set_active(true)
		else:
			all_rings_completed.emit()
