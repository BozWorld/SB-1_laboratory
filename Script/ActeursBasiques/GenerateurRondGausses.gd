extends ProcesseurAleatoire

@export var deviation := 3.0
@export var max_spheres := 2500


var mesh_sphere = preload("res://Assets/sale_gausse.tres")

var ronds : Array[MeshInstance3D]



var moy_r = 0.5
var dev_r = 0.5
var moy_v = 0.5
var dev_v = 0.5
var moy_b = 0.5
var dev_b = 0.5


func pas():
	var nouveau_rond = SaleGausse.new()
	nouveau_rond.mesh = mesh_sphere.duplicate()
	
	nouveau_rond.origine_orbite = self
	
	nouveau_rond.mesh.material = nouveau_rond.mesh.material.duplicate()
	
	nouveau_rond.mesh.material.albedo_color.r = randfn(moy_r, dev_r)
	nouveau_rond.mesh.material.albedo_color.g = randfn(moy_v, dev_v)
	nouveau_rond.mesh.material.albedo_color.b = randfn(moy_b, dev_b)
	
	nouveau_rond.position.x = randfn(0.0, deviation)
	nouveau_rond.position.y = randfn(0.0, deviation)
	nouveau_rond.position.z = randfn(0.0, deviation)
	
	if ronds.size() > max_spheres :
		var ancienne_sphere = ronds[0]
		ronds.remove_at(0)
		ancienne_sphere.queue_free()
	
	add_child(nouveau_rond)
	ronds.append(nouveau_rond)


func _on_dev_g_value_changed(value: float) -> void:
	deviation = value


func _on_moy_r_value_changed(value: float) -> void:
	moy_r = value


func _on_dev_r_value_changed(value: float) -> void:
	dev_r = value


func _on_moy_v_value_changed(value: float) -> void:
	moy_v = value


func _on_dev_v_value_changed(value: float) -> void:
	dev_v = value


func _on_moy_b_value_changed(value: float) -> void:
	moy_b = value


func _on_dev_b_value_changed(value: float) -> void:
	dev_b = value
