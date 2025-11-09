@tool
extends PathFollow3D
class_name RingsCreator

## Determine si les anneaux créés sont des anneaux bonus ou de base
@export var bonus := false

## A partir de quelle distance (en m) placer le premier anneau
@export var from:= 0.0

## Pour chaque anneau supplémentaire, faire une entrée dans l'array en inscrivant la distance (en m) qui le sépare du dernier.
@export var next_rings: Array[float] = []

## Selon les réglages du dessus créer l'anneau ou la suite d'anneau renseignée
@export_tool_button("Créer la suite d'anneaux", "Path3D") var invoke_road = road_creation

func road_creation():
	if %RingManager:
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
		
