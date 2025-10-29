extends MeshInstance3D

@export var max_alpha := 0.5

@export var boite_trails : Node3D

var trail_active : TempTrail

func actualise_mesh(input_boost : float):
	var couleur: Color = mesh.surface_get_material(0).albedo_color
	couleur.a = input_boost * max_alpha
	mesh.surface_get_material(0).albedo_color = couleur
	
	if input_boost >= 1.0 :
		trail_active = TempTrail.new()
		boite_trails.add_child(trail_active)
		trail_active.material_override = mesh.surface_get_material(0).duplicate()
