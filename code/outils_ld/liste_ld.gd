@tool
extends Resource
class_name LDList

## Array qui mémorise les positions des différentes marques
@export var array_points : Array[Transform3D]

# Signal émis quand un point est ajouté, avec son transform, il est reçu par le marker
signal point_added(_transform: Transform3D)
# Signal émis quand l'array est vidée, il est reçu par le marker
signal points_cleared

# Nettoie la liste
func _clear_list(nom_fichier):
	array_points.clear()
	points_cleared.emit()
	ResourceSaver.save(self, "res://code/outils_ld/data/" + nom_fichier + ".tres")

# Ajoute un point
func _add_point(_transform: Transform3D):
	array_points.append(_transform)
	point_added.emit(_transform)
