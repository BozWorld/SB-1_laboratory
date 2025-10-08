extends RefCounted
class_name GroundDetection

signal landing_state_changed(grounded: bool)

var character_body: CharacterBody3D
var was_grounded: bool = false

func setup(body: CharacterBody3D) -> void:
    character_body = body


func update_grounded_state(velocity: Vector3, delta: float) -> bool:
    var currently_on_floor = character_body.is_on_floor()
    var is_grounded = false

    if currently_on_floor:
        var gentle_landing = velocity.y > -5.0
        var stable_contact = was_grounded

        if gentle_landing or stable_contact:
            is_grounded = true
            _stabilize_on_ground(delta)

    if is_grounded != was_grounded:
        landing_state_changed.emit(is_grounded)
    
    was_grounded = is_grounded
    return is_grounded

func _stabilize_on_ground(delta: float) -> void:
    # Stabiliser l'avion au sol
    character_body.rotation.x = lerpf(character_body.rotation.x, 0.0, 5.0 * delta)
    character_body.rotation.z = lerpf(character_body.rotation.z, 0.0, 5.0 * delta)

func get_debug_string() -> String:
    return "Aul sol: %s\nSol détecté: %s" % ["OUI" if was_grounded else "NON", "OUI" if character_body.is_on_floor() else "NON"]