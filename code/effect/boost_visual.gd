extends MeshInstance3D

@export var max_alpha := 0.5
@export var boite_trails : Node3D

@export_category("Paramètres de Trail")
@export var trail_width_start := 0.3
@export var trail_width_end := 0.05
@export var trail_precision := 0.1
@export var resolution_cylindre := 5
@export var trail_lifetime := 1.3
@export var trail_duration := 0.5
var index_trail := 0.0
var do_trail := false

var trail_active : TempTrail

func actualise_mesh(delta: float, input_boost : float):
	var couleur: Color = mesh.surface_get_material(0).albedo_color
	couleur.a = input_boost * max_alpha
	mesh.surface_get_material(0).albedo_color = couleur
	
	if do_trail :
		index_trail += delta
		if index_trail >= trail_duration :
			do_trail = false
			index_trail = 0.0
			trail_active.genere_trail = false
	
	elif input_boost >= 1.0 :
		do_trail = true
		trail_active = TempTrail.new()
		trail_active.cible = self
		trail_active.trail_width_start = trail_width_start
		trail_active.trail_width_end = trail_width_end
		trail_active.trail_precision = trail_precision
		trail_active.resolution_cylindre = resolution_cylindre
		trail_active.trail_lifetime = trail_lifetime
		boite_trails.add_child(trail_active)
		trail_active.material_override = mesh.surface_get_material(0).duplicate()
		
