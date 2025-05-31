extends Node2D

var epices = 0.0

var mod_collecte := 0.44

var vers_proches = {}

func _on_grease_area_entered(area: Area2D) -> void:
	if area is CollisionVer :
		vers_proches.set(area, 0.0)

func _on_grease_area_exited(area: Area2D) -> void:
	if area is CollisionVer :
		vers_proches.erase(area)

func _physics_process(delta: float) -> void:
	for ver in vers_proches :
		epices += delta * mod_collecte
		vers_proches[ver] += delta * mod_collecte
		logiqueComptage()

func logiqueComptage():
	%CompteurEpices.valeur = epices
	
