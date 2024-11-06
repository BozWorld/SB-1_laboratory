extends all_ennemies

@export var anim_boss : AnimationPlayer

func _ready() -> void:
	super._ready()
	anim_boss.play("swipe")
	#self.collision_layer = 0x01
	#self.collision_mask = 0x01

func _on_area_3d_body_entered(body: Node3D) -> void:
	att_damage = 1.0
	collision_attack()


func _on_swipe_body_entered(body: Node3D) -> void:
	att_damage = 1.0
	collision_attack()
