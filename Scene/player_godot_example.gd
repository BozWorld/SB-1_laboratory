extends CharacterBody2D

@export var speed: int
@export var dir: Vector2



func _physics_process(delta: float) -> void:
	setVelocity(delta)
	move_and_slide()


func getDir():
	var finalDir = dir.normalized()
	
func setVelocity(delta):
	velocity += speed * dir * delta
	limitVelocity(Vector2(-300,-300),Vector2(300,300))
	position += velocity * delta
	
func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)
