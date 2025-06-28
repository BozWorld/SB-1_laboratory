@tool
extends Node3D

@export var vertebres_taille : Array[float] = [1.0, 1.0, 1.0, 1.0]

@export var noise : FastNoiseLite
@export var mod_temps := 0.5
var index_temps := 0.0
@export var puissance_temps := 10.0

@export_tool_button("Générer Corps")
var bouton = instantiationCorps

@export_tool_button("Détruire Corps")
var boutoon = detruireCorps

var autonome = false

@export_tool_button("Animer")
var bouton2 = lancer

@export_tool_button("Arreter")
var bouton3 = stopper

var vertebres : Array[VertebreCharnelle]

func _physics_process(delta: float) -> void:
	if position :
		vertebres[0].position = position
	position -= global_position
	
	if autonome and vertebres :
		vertebres[0].position.x = noise.get_noise_3d(index_temps,0.0,0.0) * puissance_temps
		vertebres[0].position.y = noise.get_noise_3d(0.0,index_temps,0.0) * puissance_temps
		vertebres[0].position.z = noise.get_noise_3d(0.0,0.0,index_temps) * puissance_temps
	
	index_temps += delta * mod_temps
	
	for vertebre in vertebres :
		vertebre.actualisation(delta)
	
	if !vertebres.is_empty() :
		$GenerationLiens.creationMeshCorps()

func instantiationCorps():
	detruireCorps()
	
	var derniere_vertebre : VertebreCharnelle
	for vertebre in vertebres_taille :
		var nouvelle_vertebre = VertebreCharnelle.new()
		nouvelle_vertebre.post_distance = vertebre
		vertebres.append(nouvelle_vertebre)
		if derniere_vertebre :
			nouvelle_vertebre.vertebre_precedente = derniere_vertebre
			derniere_vertebre.vertebre_suivante = nouvelle_vertebre
			nouvelle_vertebre.position.z = derniere_vertebre.position.z - 1.0
		derniere_vertebre = nouvelle_vertebre
		add_child(nouvelle_vertebre)

func detruireCorps():
	$GenerationLiens.detruireCorps()
	if vertebres :
		for vertebre in vertebres :
			vertebre.queue_free()
			vertebres = []

func lancer():
	noise.seed = abs(randi())
	autonome = true

func stopper():
	autonome = false
