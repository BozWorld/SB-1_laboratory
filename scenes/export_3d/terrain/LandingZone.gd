extends Area3D

var is_landing_available: bool = false

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    set_landing_available(false)

func set_landing_available(available: bool) -> void:
    is_landing_available = available

func _on_body_entered(body: Node) -> void:
    if is_landing_available and body.is_in_group("player"):
        print("Landing zone activated for player: ", body.name)
        get_tree().call_group("game_manager", "level_completed")