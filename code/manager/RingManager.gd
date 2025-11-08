@tool
extends Node
class_name RingManager

@export_tool_button("Nouvel Anneau", "Node3D") var create_ring := Callable(self, "add_ordered_ring")
@export_tool_button("Nouvel Anneau Bonus", "2DNodes") var create_bonus_ring := Callable(self, "add_bonus_ring")

signal ordered_ring_passed(ring_index: int)
signal all_ordered_rings_completed

var ordered_ring_scene : PackedScene = preload("res://scenes/rings/ordered_ring.tscn")
var bonus_ring_scene : PackedScene = preload("res://scenes/rings/bonus_ring.tscn")

@export var ordered_rings: Array[OrderedRing] = []:
	set(value):
		ordered_rings = value
		actualise_order_count()

@export var bonus_rings: Array[BonusRing] = []

var _current_ring_index: int = 0

func _ready() -> void:
	clear_arrays()

func actualise_order_count():
	var i=0
	for ring in ordered_rings:
		ring.ring_order = i
		i += 1

func clear_arrays():
	var i = 0
	for ring in bonus_rings:
		if !ring:
			bonus_rings.remove_at(i)
		i += 1
	i = 0
	for ring in ordered_rings:
		if !ring:
			ordered_rings.remove_at(i)
		i += 1

func add_bonus_ring(_transform: Transform3D = Transform3D.IDENTITY):
	clear_arrays()
	var ringbox : Node
	if find_child("BonusRingsBox"):
		ringbox = find_child("BonusRingsBox")
	else:
		ringbox = Node.new()
		add_child(ringbox)
		ringbox.name = "BonusRingsBox"
		ringbox.owner = get_tree().edited_scene_root
	var new_ring := bonus_ring_scene.instantiate()
	ringbox.add_child(new_ring)
	if _transform != Transform3D.IDENTITY :
		new_ring.global_transform = _transform
	else :
		new_ring.transform = ordered_rings.back().transform
	new_ring._setup(self)
	new_ring.name = "bonus_ring" + str(bonus_rings.size())
	new_ring.owner = get_tree().edited_scene_root

func add_ordered_ring(_transform: Transform3D = Transform3D.IDENTITY):
	clear_arrays()
	var ringbox : Node
	if find_child("OrderedRingsBox"):
		ringbox = find_child("OrderedRingsBox")
	else:
		ringbox = Node.new()
		add_child(ringbox)
		ringbox.name = "OrderedRingsBox"
		ringbox.owner = get_tree().edited_scene_root
	var new_ring := ordered_ring_scene.instantiate()
	ringbox.add_child(new_ring)
	if _transform != Transform3D.IDENTITY :
		new_ring.global_transform = _transform
	else:
		new_ring.transform = ordered_rings.back().transform
	new_ring._setup(self)
	new_ring.name = "ring" + str(ordered_rings.size())
	new_ring.owner = get_tree().edited_scene_root
	actualise_order_count()

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
	
	setup_bonus_rings()

func setup_bonus_rings():
	for ring in bonus_rings:
		ring._setup(self)

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
