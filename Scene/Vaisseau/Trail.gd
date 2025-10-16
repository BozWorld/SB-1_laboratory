extends MeshInstance3D

class_name Trail

var min_trail_speed: float = 8.0

@export var resolution_cylindre := 5
# === PARAMÈTRE DE TRAIL
@export var trail_enabled: bool = true
@export var trail_width_start: float = 0.3
@export var trail_width_end: float = 0.05
@export var trail_lifetime: float = 1.5
@export var trail_precision: float = 0.15
@export var trail_segments: int = 6

# === DONNÉES INTERNES ===
var _points: Array[Vector3] = []
var _basis: Array[Basis] = []
var _lifetimes: Array[float] = []
var _directions: Array[Vector3] = []
var _last_position: Vector3
var inv_cylindre : float


# === COULEURS ===
@export var color_start: Color = Color(0.9,0.9,1.0,0.8)
@export var color_end: Color = Color(0.5, 0.5, 0.8, 0.0)


func _ready() -> void:
	setup()

func _physics_process(delta: float) -> void:
	update_trail(8.5, false, delta)

func setup():
	mesh = ImmediateMesh.new()
	_last_position = global_position
	inv_cylindre = 2.0 / resolution_cylindre

func update_trail(speed: float, grounded: bool, delta: float):
	if !trail_enabled:
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
			_basis.remove_at(i)
			_lifetimes.remove_at(i)
			_directions.remove_at(i)
		else:
			i += 1

func _try_add_point():
	var current_pos = global_position
	if (_last_position - current_pos).length() > trail_precision:
		_add_point()
		_last_position = current_pos

func _add_point():
	var direction = Vector3.FORWARD
	if _points.size() > 0:
		direction = (global_position - _points[-1]).normalized()
		
	_points.append(global_position)
	_basis.append(global_basis)
	_directions.append(direction)
	_lifetimes.append(0.0)

func _clear_trail():
	_points.clear()
	_basis.clear()
	_lifetimes.clear()
	_directions.clear()
	if mesh:
		mesh.clear_surfaces()

func _rebuild_mesh():
	if _points.size() < 2:
		if mesh:
			mesh.clear_surfaces()
		return
	
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(_points.size() - 1):
		var t_current = float(i) / (_points.size() - 1.0)
		var t_next = float(i + 1) / (_points.size() - 1.0)

		var color_current = color_start.lerp(color_end, 1.0 - t_current)
		var color_next = color_start.lerp(color_end, 1.0 - t_next)

		var width_current = lerp(trail_width_start, trail_width_end, t_current)
		var width_next = lerp(trail_width_start, trail_width_end, t_next)

		_create_quad_segment(i, width_current, width_next, color_current, color_next)
	
	mesh.surface_end()

func _create_quad_segment(index: int, width1: float, width2: float, color1: Color, color2: Color):
	var pos1 = to_local(_points[index])
	var pos2 = to_local(_points[index+1])

	var direction = (pos2 - pos1).normalized()
	var up = Vector3.UP
	var right = direction.cross(up).normalized()

	if right.length() < 0.1:
		right = Vector3.RIGHT
	

	if resolution_cylindre < 2 :
			

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

	else :
		

		var basis1 = _basis[index]
		var basis2 = _basis[index+1]

		var points_cylindre1 : Array[Vector3] = []
		var points_cylindre2 : Array[Vector3] = []

		for i in range(resolution_cylindre) :
			var rota = i * inv_cylindre
			print(rota)

			var nouveau_point1 = basis1.x * width1 * 0.5
			nouveau_point1 = nouveau_point1.rotated(basis1.y, rota * PI)
			points_cylindre1.append(nouveau_point1)
			
			var nouveau_point2 = basis2.x * width2 * 0.5
			nouveau_point2 = nouveau_point2.rotated(basis2.y, rota * PI)
			points_cylindre2.append(nouveau_point2)

		for i in range(resolution_cylindre):

			if i != 0 :
				# Left et right dans le referentiel de l'axe du point du cylindre
				var p1_left = pos1 + points_cylindre1[i]
				var p1_right = pos1 + points_cylindre1[i-1]
				var p2_left = pos2 + points_cylindre2[i]
				var p2_right = pos2 + points_cylindre2[i-1]

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
			else :
				
				# Left et right dans le referentiel de l'axe du point du cylindre
				var p1_left = pos1 + points_cylindre1[i]
				var p1_right = pos1 + points_cylindre1[resolution_cylindre - 1]
				var p2_left = pos2 + points_cylindre2[i]
				var p2_right = pos2 + points_cylindre2[resolution_cylindre - 1]

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
	var points_count = _points.size()
	return "Trail System: (%d points)" % [points_count]
