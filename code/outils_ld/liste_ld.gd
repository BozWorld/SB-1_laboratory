@tool
extends Resource
class_name LDList

@export var array_points : Array[Transform3D]

signal point_added(_transform: Transform3D)
signal points_cleared

func _clear_list(nom_fichier):
	array_points.clear()
	points_cleared.emit()
	ResourceSaver.save(self, "res://code/outils_ld/" + nom_fichier + ".tres")

func _add_point(_transform: Transform3D):
	array_points.append(_transform)
	point_added.emit(_transform)
