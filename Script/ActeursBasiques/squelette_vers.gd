extends Node3D

@export var ancre : Node3D
var vertebres : Array[Vertebre]
var derniere_vertebre : Node3D

@export var frequence_bruit := 0.7
var index_bruit := 0.0
var temps := 0.0
@export var pas_temps := 0.1
@export var bruit := FastNoiseLite.new()

@export var distance_bruit := 0.5

func _physics_process(delta: float) -> void:
	position -= global_position
	
	index_bruit += delta
	if index_bruit >= frequence_bruit :
		index_bruit -= frequence_bruit
		corpulenceBruitee()
	
	for vertebre in vertebres :
		vertebre.actualisation(delta)
	

func _ready() -> void:
	vertebres.append(ancre)
	for vertebre in get_children() :
		if !derniere_vertebre :
			vertebre.vertebre_precedente = ancre
			ancre.vertebre_suivante = vertebre
			
		else :
			vertebre.vertebre_precedente = derniere_vertebre
			derniere_vertebre.vertebre_suivante = vertebre
			
		vertebres.append(vertebre)
		derniere_vertebre = vertebre
	

func corpulenceBruitee():
	for vertebre in vertebres :
		#vertebre.mesh.mesh.radius = 0.9 + 0.5 * bruit.get_noise_1d(temps + distance_bruit * (vertebres.size()-vertebres.find(vertebre)))
		#vertebre.mesh.mesh.height = 2*vertebre.mesh.mesh.radius
		vertebre.scale.x = 1.0 + 0.5 * bruit.get_noise_1d(temps + distance_bruit * (vertebres.size()-vertebres.find(vertebre)))
		vertebre.scale.y = 1.0 + 0.5 * bruit.get_noise_1d(temps + distance_bruit * (vertebres.size()-vertebres.find(vertebre)))
		vertebre.scale.z = 1.0 + 0.5 * bruit.get_noise_1d(temps + distance_bruit * (vertebres.size()-vertebres.find(vertebre)))
		vertebre.post_distance = 0.3 + 0.3 * bruit.get_noise_1d(temps + distance_bruit * (vertebres.size()-vertebres.find(vertebre)))
		
	temps += pas_temps
