extends CharacterBody3D
class_name PlaneController


# === SIGNAUX ===
signal landed
signal took_off
signal speed_changed(new_speed: float)
signal boom_effect_triggered(intensity: float)

# === Manager ===
var _flight_physics: FlightPhysics
var _input_handler: InputHandler
var _ground_detection: GroundDetection
var _gravity_handler: GravityHandler
@export var _trails : Array[Trail]
var _trail_system: UnifiedTrailSystem
var _plane_animation: PlaneAnimation
@export var flight_config: FlightConfiguration
@export var time_label: RichTextLabel
@export var rings_label: RichTextLabel
@export var landing_label: RichTextLabel

# === EXPORTS ===
@export var debug_ui: RichTextLabel

@export var seuil_explosion := 10.0

# === VARIABLE D'ËTAT ==
var current_speed: float = 0.0
var is_grounded: bool = false



# === INITIALISATION ===
func _ready():
	_initialize_systems()
	_connect_signals()
	_setup_initial_state()

func _initialize_systems():
	_flight_physics = FlightPhysics.new()
	_input_handler = InputHandler.new()
	_ground_detection = GroundDetection.new()
	_plane_animation = PlaneAnimation.new()
	_gravity_handler = GravityHandler.new()

	_flight_physics.setup(flight_config if flight_config else _create_default_config())
	_ground_detection.setup(self)
	for trail in _trails :
		trail.setup()
	_plane_animation.setup(get_node_or_null("plane_mesh"),  get_node_or_null("effect/helice"))
	_gravity_handler.setup()
	
func _connect_signals():
	_ground_detection.landing_state_changed.connect(_on_landing_state_changed)
	_flight_physics.speed_updated.connect(_on_speed_updated)
	_flight_physics.boom_triggered.connect(_on_boom_triggered)

func _setup_initial_state():
	add_to_group("player")

# === BOUCLE PRINCIPALE ===
func _physics_process(delta: float) -> void:
	var input_data = _input_handler.get_input_data(delta, current_speed, is_grounded)
	var input_boost =_input_handler.get_input_boost(delta)
	
	if input_boost == 1.0 :
		_flight_physics.boost = true
	
	if %boost_visual:
		%boost_visual.actualise_mesh(delta, input_boost)
	
	var physics_result = _flight_physics.update_physics(input_data, delta, is_grounded)
	current_speed = physics_result.speed

	_apply_movement(physics_result, delta)
	is_grounded = _ground_detection.update_grounded_state(velocity, delta)

	_plane_animation.update_animations(physics_result, is_grounded, delta)

	for trail in _trails :
		trail.update_trail(delta)

	_update_debug_info()
	

	
	var collided := move_and_slide()
	if collided:
		var collision := get_last_slide_collision()
		if current_speed >= 30.0:
			if (to_local(collision.get_position()).normalized() + basis.z).length() <= 0.6:
				print("COLLISION")
				queue_free()



func _apply_movement(physics_result: PhysicsResult, delta: float):
	# Appliquer les rotations
	if not is_grounded or abs(physics_result.pitch_input) > 0:
		transform.basis = transform.basis.rotated(transform.basis.x, physics_result.pitch_input *  delta)
		#if !is_grounded:
			#transform.basis = transform.basis.rotated(Vector3.LEFT, _gravity_handler._get_angular_force(-basis.z) * delta)
	
	transform.basis = transform.basis.rotated(Vector3.UP, physics_result.turn_input * delta)
	
	
	basis = basis.orthonormalized()
	
	velocity = -transform.basis.z * current_speed
	
	if physics_result.should_takeoff:
		velocity.y += physics_result.takeoff_force * delta
	
	if !is_grounded :
		velocity += _gravity_handler._get_linear_force(-basis.z, velocity.length()) * delta
	else :
		_gravity_handler.set_gravity_magnitude(0.0)
	
# === GESTIONNAIRE D'EVËNEMENTS ===
func _on_landing_state_changed(grounded: bool) -> void:
	if grounded != is_grounded:
		if grounded:
			landed.emit()
		else:
			took_off.emit()

func _on_speed_updated(speed: float):
	speed_changed.emit(speed)

func _on_boom_triggered(intensity: float):
	_plane_animation.trigger_boom_effect(intensity)
	boom_effect_triggered.emit(intensity)
	print("PlaneController: Boom effect déclenché avec intensité %.2f" % intensity)

# === MÉTHODE UTILITAIRES ===
func _update_debug_info():
	pass
	#if debug_ui:
		#var texte_trails : String
		#for trail in _trails :
			#texte_trails += trail.get_debug_string()
		#debug_ui.text = ( 
			#_flight_physics.get_debug_string() + "\n" +
			#texte_trails + "\n" +
			#_plane_animation.get_debug_string() + "\n"
			#
		#)

func _create_default_config() -> FlightConfiguration:
	var config = FlightConfiguration.new()
	config.min_flight_speed = 8.0
	config.max_flight_speed = 35.0
	config.turn_speed = 1.2
	config.pitch_speed = 2.0
	return config

# === MËTHODE PUBLIQUES ===
func get_current_speed() -> float:
	return current_speed

func is_plane_grounded() -> bool:
	return is_grounded
