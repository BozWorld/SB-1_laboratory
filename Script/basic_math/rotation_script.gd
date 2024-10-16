extends Node2D

var rot_vel = 0
@export var rot_acc: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_viewport_rect().size.x/2
	position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
	if Input.is_action_just_pressed("click"):
		rot_acc += 100	
		print("hello")
		return			
	rot_vel += rot_acc * delta
	rotation += rot_vel * delta
	rot_acc = 0
	print(rot_vel)
	pass
