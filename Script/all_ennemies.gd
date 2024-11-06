@tool
extends CollisionObject3D

class_name all_ennemies
@export var e_health : float
@export var att_damage : float
signal attack_connect(damage)

func _ready() -> void:
	collision_layer = collision_layer | 0x08
	collision_mask = collision_mask | 0x08
	DamageHandler.add_ennemies(self)

func collision_attack():
	attack_connect.emit(att_damage)
