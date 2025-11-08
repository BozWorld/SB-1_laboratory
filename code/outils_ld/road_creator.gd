@tool
extends PathFollow3D
class_name RingsCreator

@export var bonus := false

@export var from:= 0.0

@export var next_rings: Array[float] = []

@export_tool_button("Créer la suite d'anneaux", "Path3D") var invoke_road = road_creation



func road_creation():
	progress = from
	if bonus:
		%RingManager.add_bonus_ring(global_transform)
		for distance in next_rings:
			progress += distance
			%RingManager.add_bonus_ring(global_transform)
	else :
		%RingManager.add_ordered_ring(global_transform)
		for distance in next_rings:
			progress += distance
			%RingManager.add_ordered_ring(global_transform)
		
