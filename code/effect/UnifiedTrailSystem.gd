extends RefCounted
class_name UnifiedTrailSystem

var trail_node: MeshInstance3D
var min_trail_speed: float = 8.0


# === PARAMÈTRE DE TRAIL
@export var trail_enabled: bool = true
@export var trail_width_start: float = 0.3
@export var trail_width_end: float = 0.05
@export var trail_lifetime: float = 1.5
@export var trail_precision: float = 0.15
@export var trail_segments: int = 6

# === DONNÉES INTERNES ===
var _points: Array[Vector3] = []
var _lifetimes: Array[float] = []
var _directions: Array[Vector3] = []
var _last_position: Vector3

# === COULEURS ===
var color_start: Color = Color(0.9,0.9,1.0,0.8)
var color_end: Color = Color(0.5, 0.5, 0.8, 0.0)

func setup(trail: MeshInstance3D):
	trail_node = trail
	if trail_node:
		trail_node.mesh = ImmediateMesh.new()
		_last_position = trail_node.global_position

func update_trail(speed: float, grounded: bool, delta: float):
	if not trail_node or not trail_enabled:
		return

	_update_points_lifetime(delta)

	var should_emit = trail_enabled and speed >= min_trail_speed and not grounded
	if should_emit:
		_try_add_point()
	elif not trail_enabled:
		_clear_trail()

	_rebuild_mesh()

func _update_points_lifetime(delta: float):
	var i = 0
	while i < _points.size():
		_lifetimes[i] += delta
		if _lifetimes[i] >= trail_lifetime:
			_points.remove_at(i)
			_lifetimes.remove_at(i)
			_directions.remove_at(i)
		else:
			i += 1

func _try_add_point():
	var current_pos = trail_node.global_position
	if (_last_position - current_pos).length()  > trail_precision:
		_add_point(current_pos)
		_last_position = current_pos

func _add_point(position: Vector3):
	var direction = Vector3.FORWARD
	if _points.size() > 0:
		direction = (position - _points[-1]).normalized()
	
	_points.append(position)
	_directions.append(direction)
	_lifetimes.append(0.0)

func _clear_trail():
	_points.clear()
	_lifetimes.clear()
	_directions.clear()
	if trail_node and trail_node.mesh:
		trail_node.mesh.clear_surfaces()

func _rebuild_mesh():
	if not trail_node or _points.size() < 2:
		if trail_node and trail_node.mesh:
			trail_node.mesh.clear_surfaces()
		return
	
	var mesh = trail_node.mesh as ImmediateMesh
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(_points.size() - 1):
		var t_current = float(i) / (_points.size() - 1.0)
		var t_next = float(i + 1) / (_points.size() - 1.0)

		var color_current = color_start.lerp(color_end, 1.0 - t_current)
		var color_next = color_start.lerp(color_end, 1.0 - t_next)

		var width_current = lerp(trail_width_start, trail_width_end, t_current)
		var width_next = lerp(trail_width_start, trail_width_end, t_next)

		_create_quad_segment(i, width_current, width_next, color_current, color_next, mesh)
	
	mesh.surface_end()

func _create_quad_segment(index: int, width1: float, width2: float, color1: Color, color2: Color, mesh: ImmediateMesh):
	var pos1 = trail_node.to_local(_points[index])
	var pos2 = trail_node.to_local(_points[index+1])

	var direction = (pos2 - pos1).normalized()
	var up = Vector3.UP
	var right = direction.cross(up).normalized()

	if right.length() < 0.1:
		right = Vector3.RIGHT
	
	var p1_left = pos1 - right * width1 * 0.5
	var p1_right = pos1 + right * width1 * 0.5
	var p2_left = pos2 - right * width2 * 0.5
	var p2_right = pos2 + right * width2 * 0.5

	mesh.surface_set_color(color1)
	mesh.surface_add_vertex(p1_left)
	mesh.surface_set_color(color2)
	mesh.surface_add_vertex(p2_left)
	mesh.surface_set_color(color1)
	mesh.surface_add_vertex(p1_right)

	mesh.surface_set_color(color1)
	mesh.surface_add_vertex(p1_right)
	mesh.surface_set_color(color2)
	mesh.surface_add_vertex(p2_left)
	mesh.surface_set_color(color2)
	mesh.surface_add_vertex(p2_right)

func set_trail_enabled(enabled: bool):
	trail_enabled = enabled
	if not enabled:
		_clear_trail()


func get_debug_string() -> String:
	var status = "ACTTIF" if trail_enabled else "INACTIF"
	var points_count = _points.size()
	return "Trail System: %s (%d points)" % [status, points_count]
