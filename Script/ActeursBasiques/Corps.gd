@tool
extends Node3D

@export var vertebres_taille := [1.0, 1.0, 1.0, 1.0]

@export_tool_button("Générer Corps")
var bouton = instantiationCorps

var vertebres : Array[Vertebre]

#func _physics_process(delta: float) -> void:
	#position -= global_position
	

func instantiationCorps():
	if vertebres :
		for vertebre in vertebres :
			vertebre.queue_free()
	
	var derniere_vertebre : Vertebre
	for vertebre in vertebres_taille :
		var nouvelle_vertebre = Vertebre.new()
		nouvelle_vertebre.post_distance = vertebre
		vertebres.append(nouvelle_vertebre)
		if derniere_vertebre :
			nouvelle_vertebre.vertebre_precedente = derniere_vertebre
			derniere_vertebre.vertebre_suivante = nouvelle_vertebre
			nouvelle_vertebre.position.z = derniere_vertebre.position.z - 1.0
		derniere_vertebre = nouvelle_vertebre
		add_child(nouvelle_vertebre)

func _ready() -> void:
	instantiationCorps()
