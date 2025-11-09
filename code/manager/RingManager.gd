@tool
extends Node
class_name RingManager

## Crée un anneau au bout de la suite des anneaux basiques.
@export_tool_button("Nouvel Anneau", "Node3D") var create_ring := Callable(self, "add_ordered_ring")
## Crée un anneau bonus.
@export_tool_button("Nouvel Anneau Bonus", "2DNodes") var create_bonus_ring := Callable(self, "add_bonus_ring")

# Signal émis lorsqu'un anneau de base est passé, reçu par le Manager
signal ordered_ring_passed(ring_index: int)
# Signal émis quand tous les anneaux basiques ont été passés.
signal all_ordered_rings_completed

# Ref aux scenes des différents types d'anneaux.
var ordered_ring_scene : PackedScene = preload("res://scenes/rings/ordered_ring.tscn")
var bonus_ring_scene : PackedScene = preload("res://scenes/rings/bonus_ring.tscn")

## Liste des anneaux basiques, peut être réarrangée pour changer l'ordre dans la suite.
@export var ordered_rings: Array[OrderedRing] = []:
	set(value):
		ordered_rings = value
		actualise_order_count()

## Liste des anneaux bonus, l'ordre n'a pas beaucoup d'intérêt, je crois.
@export var bonus_rings: Array[BonusRing] = []

# Index pour les anneaux de base pour savoir où en est l'avion.
var _current_ring_index: int = 0


func _ready() -> void:
	clear_arrays()
	actualise_order_count()

# Corrige les potentielles erreurs dans les variables des anneaux sur leur placement dans la suite.
func actualise_order_count():
	var i=0
	for ring in ordered_rings:
		ring.ring_order = i
		i += 1

# Si il y a des entrées vides dans les array, ou des doublons on nettoie tout ça
func clear_arrays():
	var i = 0
	for ring in bonus_rings:
		if !ring:
			bonus_rings.remove_at(i)
		elif bonus_rings.find(ring) != i:
			bonus_rings.remove_at(i)
		i += 1
	i = 0
	for ring in ordered_rings:
		if !ring:
			ordered_rings.remove_at(i)
		elif ordered_rings.find(ring) != i:
			ordered_rings.remove_at(i)
		i += 1

# Fonction à appeler pour créer un anneau bonus
func add_bonus_ring(_transform: Transform3D = Transform3D.IDENTITY):
	# Un petit nettoyage et de rangement ça n'a rien de mal
	clear_arrays()
	actualise_order_count()
	var ringbox : Node
	if find_child("BonusRingsBox"):
		ringbox = find_child("BonusRingsBox")
	else:
		ringbox = Node.new()
		add_child(ringbox)
		ringbox.name = "BonusRingsBox"
		ringbox.owner = get_tree().edited_scene_root
	
	# Instancie un anneau dans le tiroir créé à ce but
	var new_ring := bonus_ring_scene.instantiate()
	ringbox.add_child(new_ring)
	
	# Si un transform est spécifié, on le donne au nouvel anneau, sinon il
	# hérite du même que le précédent.
	if _transform != Transform3D.IDENTITY :
		new_ring.global_transform = _transform
	else :
		new_ring.transform = ordered_rings.back().transform
		
	# On lance le setup de l'anneau, et on fait en sorte de le rendre persistant
	new_ring._setup(self)
	new_ring.name = "bonus_ring" + str(bonus_rings.size())
	new_ring.owner = get_tree().edited_scene_root

# Fonction à appeler pour créer un anneau normal
func add_ordered_ring(_transform: Transform3D = Transform3D.IDENTITY):
	# Un brin de nettoyage et de rangement ça na que du bon
	clear_arrays()
	actualise_order_count()
	var ringbox : Node
	if find_child("OrderedRingsBox"):
		ringbox = find_child("OrderedRingsBox")
	else:
		ringbox = Node.new()
		add_child(ringbox)
		ringbox.name = "OrderedRingsBox"
		ringbox.owner = get_tree().edited_scene_root
	
	# On instancie l'anneau dans le tiroir prévu à cet effet.
	var new_ring := ordered_ring_scene.instantiate()
	ringbox.add_child(new_ring)
	
	# Si un transform est spécifié, on le donne au nouvel anneau, sinon il
	# hérite du même que le précédent.
	if _transform != Transform3D.IDENTITY :
		new_ring.global_transform = _transform
	else:
		new_ring.transform = ordered_rings.back().transform
	
	# On lance le setup de l'anneau, et on fait en sorte de le rendre persistant
	new_ring._setup(self)
	new_ring.name = "ring" + str(ordered_rings.size())
	new_ring.owner = get_tree().edited_scene_root
	
	# Tjr ranger derrière soi
	actualise_order_count()

# Fonction appelée par le Manager, pour setup les différents anneaux.
func setup_rings():
	setup_ordered_rings()
	setup_bonus_rings()

# Setup des anneaux normaux.
func setup_ordered_rings():
	_current_ring_index = 0

	for i in ordered_rings.size():
		print("Setting up ring: ", i)
		print("Ring path: ", ordered_rings[i])
		var ring = ordered_rings[i]
		print("Ring node: ", ring)
		ring._setup(self)
		ring.ring_order = i 
		ring.ring_passed_ordoredly.connect(on_ring_passed)
		if i == 0:
			ring.set_active(true)
		elif i == 1:
			ring.set_active(false, true)
		else:
			ring.set_active(false)

# Setup des anneaux bonus
func setup_bonus_rings():
	for ring in bonus_rings:
		ring._setup(self)

# Quand un anneau est passé on previent les prochains pour qu'ils se préparent
func on_ring_passed(ring_order: int):
	if ring_order == _current_ring_index:
		ordered_rings[_current_ring_index].set_active(false)
		_current_ring_index += 1
		ordered_ring_passed.emit(ring_order)
		
		if _current_ring_index < ordered_rings.size():
			ordered_rings[_current_ring_index].set_active(true)
			if _current_ring_index < ordered_rings.size() - 1:
				ordered_rings[_current_ring_index + 1].set_active(false, true)
		else:
			all_ordered_rings_completed.emit()

# Fonction à appeler pour changer l'ordre d'un anneau
func change_ring_order(index: int, to: int):
# Vérification des limites
	if index < 0 or index >= ordered_rings.size():
		push_error("Index source invalide: " + str(index))
		return
	if to < 0 or to >= ordered_rings.size():
		push_error("Index destination invalide: " + str(to))
		return
	
	# Si les index sont identiques, rien à faire
	if index == to:
		return
	
	# Extraire l'élément à déplacer
	var element = ordered_rings[index]
	
	# Supprimer l'élément de sa position initiale
	ordered_rings.remove_at(index)
	
	# L'insérer à sa nouvelle position
	ordered_rings.insert(to, element)
