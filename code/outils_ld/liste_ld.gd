@tool
extends Resource
class_name LDList

@export_tool_button("Clear Level", "Checkerboard") var cleaning := _clear_list


@export var array_points : Array[Vector3]

signal point_added(_position: Vector3)
signal points_cleared

func _clear_list():
	array_points.clear()
	points_cleared.emit()
	ResourceSaver.save(self, "res://code/outils_ld/liste1.tres")

func _add_point(_position: Vector3):
	array_points.append(_position)
	point_added.emit(_position)
