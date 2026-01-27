@tool
extends Path3D
class_name LDTracker

@export var target: CharacterBody3D

@export var frequence_track := 0.1
@export var memoire : Memoire
@export var nom_memoire := "memoire_fantome"
var index := 0.0
var duration:= 0.0

@export var track := true

func _ready() -> void:
	if !Engine.is_editor_hint() :
		curve.clear_points()

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint() and track:
		index += delta
		duration += delta
		if index >= frequence_track:
			index -= frequence_track
			if target :
				add_point_from_target()
	elif Engine.is_editor_hint():
		if curve != memoire.curve:
			curve = memoire.curve
		

func add_point_from_target():
	curve.add_point(target.position, target.basis.z, -target.basis.z)
	memoire.curve = curve
	memoire.duration = duration
	ResourceSaver.save(memoire, "res://code/outils_ld/data/" + nom_memoire + ".tres")
