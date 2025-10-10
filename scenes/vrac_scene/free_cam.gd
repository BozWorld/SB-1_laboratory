extends Camera3D

@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 6.0
@export var fast_multiplier: float = 3.0
@export var slow_multiplier: float = 0.3
@export var acceleration: float = 12.0
@export var invert_y: bool = false
@export var start_captured: bool = true
@export var make_current_on_ready: bool = true

var _yaw := 0.0
var _pitch := 0.0
var _vel := Vector3.ZERO

func _ready() -> void:
    current = make_current_on_ready
    _yaw = rotation.y
    _pitch = rotation.x
    if start_captured:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    _ensure_actions()

func _exit_tree() -> void:
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        var inv := 1.0 if invert_y else -1.0
        _yaw += event.relative.x * mouse_sensitivity
        _pitch = clamp(_pitch + event.relative.y * mouse_sensitivity * inv, deg_to_rad(-89.0), deg_to_rad(89.0))
        rotation = Vector3(_pitch, _yaw, 0.0)
    elif event.is_action_pressed("fc_toggle_mouse"):
        var captured := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if captured else Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
    var local_dir := Vector3.ZERO
    local_dir.x = int(Input.is_action_pressed("fc_right")) - int(Input.is_action_pressed("fc_left"))
    local_dir.y = int(Input.is_action_pressed("fc_up")) - int(Input.is_action_pressed("fc_down"))
    local_dir.z = int(Input.is_action_pressed("fc_back")) - int(Input.is_action_pressed("fc_forward"))
    if local_dir != Vector3.ZERO:
        local_dir = local_dir.normalized()

    var speed := move_speed
    if Input.is_action_pressed("fc_fast"):
        speed *= fast_multiplier
    if Input.is_action_pressed("fc_slow"):
        speed *= slow_multiplier

    var target_vel := local_dir * speed
    _vel = _vel.lerp(target_vel, 1.0 - exp(-acceleration * delta))
    translate_object_local(_vel * delta)

func _ensure_actions() -> void:
    _add_key_action("fc_forward", KEY_Z) # ZQSD
    _add_key_action("fc_back",    KEY_S)
    _add_key_action("fc_left",    KEY_Q)
    _add_key_action("fc_right",   KEY_D)
    _add_key_action("fc_up",      KEY_SPACE)
    _add_key_action("fc_down",    KEY_CTRL)
    _add_key_action("fc_fast",    KEY_SHIFT)
    _add_key_action("fc_slow",    KEY_ALT)
    _add_key_action("fc_toggle_mouse", KEY_ESCAPE)
    _add_mouse_button_action("fc_toggle_mouse", MOUSE_BUTTON_RIGHT)

func _add_key_action(name: String, keycode: int) -> void:
    if not InputMap.has_action(name):
        InputMap.add_action(name)
    var ev := InputEventKey.new()
    ev.keycode = keycode
    if not InputMap.action_has_event(name, ev):
        InputMap.action_add_event(name, ev)

func _add_mouse_button_action(name: String, button: MouseButton) -> void:
    if not InputMap.has_action(name):
        InputMap.add_action(name)
    var ev := InputEventMouseButton.new()
    ev.button_index = button
    if not InputMap.action_has_event(name, ev):
        InputMap.action_add_event(name, ev)
