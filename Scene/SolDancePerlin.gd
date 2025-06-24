extends Node3D

var liste_colonnes : Array[MeshInstance3D]

signal changement_bpm

signal pas_effectue

var index_delta = 0.0
var seuil_delta = 0.5

@export var perlin : FastNoiseLite
var temps := 0.0
@export var pas_temps := 0.01

@export var espacement_perlin := 0.44

@export var puissance_croissance := 1.0

@export_range(0.0,500.0, 1.0, "or_greater") var bpm = 120.0 :
	set(value):
		bpm = value
		seuil_delta = 60.0 / value
		changement_bpm.emit()

func _ready() -> void:
	for colonne in get_children() :
		colonne.mesh = colonne.mesh.duplicate()
		colonne.mesh.material = colonne.mesh.material.duplicate()
		liste_colonnes.append(colonne)

func _physics_process(delta: float) -> void:
	index_delta += delta
	if index_delta >= seuil_delta :
		index_delta -= seuil_delta
		pas()
		pas_effectue.emit()

func pas():
	temps += pas_temps
	for colonne in liste_colonnes:
		print(perlin.get_noise_2d(colonne.position.x * espacement_perlin + temps, colonne.position.z * espacement_perlin))
		colonne.mesh.size.y = (1.0 + perlin.get_noise_2d(colonne.position.x * espacement_perlin + temps, colonne.position.z * espacement_perlin)) * puissance_croissance
		var choix_rvb : Vector3
		
		choix_rvb.x = abs(perlin.get_noise_2d(100.0 + colonne.position.x * espacement_perlin, temps + colonne.position.z * espacement_perlin))
		choix_rvb.y = abs(perlin.get_noise_2d(temps + colonne.position.x * espacement_perlin, 100.0 + colonne.position.z * espacement_perlin))
		choix_rvb.z = abs(perlin.get_noise_2d(100 + temps + colonne.position.x * espacement_perlin, 100 + temps + colonne.position.z * espacement_perlin))
		
		colonne.mesh.material.albedo_color.r = choix_rvb.x
		colonne.mesh.material.albedo_color.g = choix_rvb.y
		colonne.mesh.material.albedo_color.b = choix_rvb.z
	#liste_colonnes[choix].size.y += puissance_croissance
