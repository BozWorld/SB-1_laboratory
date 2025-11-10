extends MeshInstance3D
class_name BoostVisual

@export var max_alpha := 1.0
@export var boite_trails : Node3D

@export var brake_min:= 0.0:
	set(value):
		brake_min = value
		inv_brake_max = 1.0/brake_max - value
@export var brake_max:= 0.5:
	set(value):
		brake_max = value
		inv_brake_max = 1.0/value - brake_min
var inv_brake_max:= 2.0
@export_category("Paramètres de Trail")
@export var width_mod_over_time: Curve
@export var trail_width_start := 0.3
@export var trail_width_end := 0.05
@export var trail_precision := 0.1
@export var resolution_cylindre := 5
@export var trail_lifetime := 1.3
@export var trail_latency := 0.5:
	set(value):
		trail_latency = value
		inv_trail_latency = 1.0/value
var inv_trail_latency:= 2.0
var index_trail := 0.0
var do_trail := false

var config: FlightConfiguration

var index_curve:= 0.0

var trail_active : TempTrail

var width_mod:= 1.0

func _create_trail():
	trail_active = TempTrail.new()
	trail_active.cible = self
	trail_active.trail_width_start = trail_width_start
	trail_active.trail_width_end = trail_width_end
	trail_active.trail_precision = trail_precision
	trail_active.resolution_cylindre = resolution_cylindre
	trail_active.trail_lifetime = trail_lifetime
	trail_active.genere_trail = true
	boite_trails.add_child(trail_active)
	trail_active.material_override = mesh.surface_get_material(0).duplicate()
		

func update_boost_vfx(delta: float, brake: float, boost: bool):
	var couleur: Color = mesh.surface_get_material(0).albedo_color
	couleur.a = clampf(clampf(brake-brake_min,0.0,1.0) * inv_brake_max, 0.0, 1.0)
	mesh.surface_get_material(0).albedo_color = couleur
	
	
	if do_trail:
		if !boost:
			index_trail += delta
			width_mod *= (trail_latency - index_trail) * inv_trail_latency
		if index_trail >= trail_latency :
			do_trail = false
			index_trail = 0.0
			trail_active.genere_trail = false
		else:
			index_curve += delta
			width_mod = width_mod_over_time.sample(index_curve * config.inv_boost_max_duration)
			trail_active.width_mod = width_mod
	
	elif boost and brake > brake_min:
		index_curve = 0.0
		do_trail = true
		index_trail = 0.0
		_create_trail()
		print("TRAIL ACTIVEE")
		var width_mod = width_mod_over_time.sample(index_curve)
		trail_active.width_mod = width_mod
