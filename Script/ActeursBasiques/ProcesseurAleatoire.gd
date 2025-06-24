extends Node3D
class_name ProcesseurAleatoire

signal changement_bpm

signal pas_effectue

var index_delta = 0.0
var seuil_delta = 0.5
	
@export_range(0.0,500.0, 1.0, "or_greater") var bpm = 120.0 :
	set(value):
		bpm = value
		seuil_delta = 60.0 / value
		changement_bpm.emit()


func _physics_process(delta: float) -> void:
	index_delta += delta
	if index_delta >= seuil_delta :
		index_delta -= seuil_delta
		pas()
		pas_effectue.emit()

func pas():
	pass
