extends Marker3D

@export var mat_trail : Material

@export var largeur_debut := 0.2
@export var largeur_fin := 0.01

@export var mod_duree := 1.0

@export var boost : MeshInstance3D

@export var resolution_cylindre := 5

@export var trail_precision: float = 0.15

var trail : TempTrail