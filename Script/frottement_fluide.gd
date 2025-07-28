extends Node3D

@export var coef_aero := 0.2

var surface := 0.1

@onready var parent = get_parent()

var densite_air := 0.00012
var densite_actuelle := 0.00012

func _ready() -> void:
	%Area3D.area_entered.connect(entreeFluide)
	%Area3D.area_exited.connect(sortieFluide)

func entreeFluide(area : Area3D):
	if area is Fluide :
		densite_actuelle = area.densite

func sortieFluide(_area : Area3D):
	if %Area3D.has_overlapping_areas() :
		for fluide in %Area3D.get_overlapping_areas() :
			if fluide is Fluide :
				if fluide.densite > densite_actuelle :
					densite_actuelle = fluide.densite
					
	else :
		densite_actuelle = densite_air

func calculFrottement():
	var velocite = parent.velocite
	var frottement_mag = 0.5 * (velocite.length() * velocite.length()) * densite_actuelle * coef_aero * surface 
	#print(densite_actuelle)
	#var frottement = (-velocite.normalized() * clampf(frottement_mag, 0.0, velocite.length()))
	
	var frottement = (-velocite.normalized() * frottement_mag)
	print("frottements : " + str(frottement))
	#print(%Area3D.global_position)
	return frottement
