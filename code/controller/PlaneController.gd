extends CharacterBody3D
class_name PlaneController


# === SIGNAUX ===
signal landed
signal took_off
signal speed_changed(new_speed: float)
signal boom_effect_triggered(intensity: float)

# === Manager ===
var _flight_physics: FlightPhysics
var _water_handler: WaterHandler
var _input_handler: InputHandler
var _ground_detection: GroundDetection
var _gravity_handler: GravityHandler
@export var _trails : Array[Trail]
var _plane_animation: PlaneAnimation
@export var flight_config: FlightConfiguration
@export var rings_label: RichTextLabel
@export var landing_label: RichTextLabel

@export var boost_visuals: Array[BoostVisual]

@export var son_avion: AudioStream
@export var son_moteur : AudioStream
var hydravion := false

var brake := 0.0

var inv_pitch:= false

var bruit_vent: AudioStreamPlayer
var bruit_moteur : AudioStreamPlayer

# === EXPORTS ===
@export var debug_ui: RichTextLabel

@export var seuil_explosion := 10.0

# === VARIABLE D'ËTAT ==
var current_speed: float = 0.0
var is_grounded: bool = false

@onready var cam_follow:= %follower

# === INITIALISATION ===
func _ready():
	_initialize_systems()
	_connect_signals()
	_setup_initial_state()

func _initialize_systems():
	_flight_physics = FlightPhysics.new()
	_water_handler = WaterHandler.new()
	_input_handler = InputHandler.new()
	_ground_detection = GroundDetection.new()
	_plane_animation = PlaneAnimation.new()
	_gravity_handler = GravityHandler.new()
	bruit_vent = AudioStreamPlayer.new()
	add_child(bruit_vent)
	bruit_vent.stream = son_avion
	bruit_vent.finished.connect(Callable(bruit_vent, "play"))
	bruit_vent.play()
	bruit_vent.volume_db = -40.0
	bruit_moteur = AudioStreamPlayer.new()
	add_child(bruit_moteur)
	bruit_moteur.stream = son_moteur
	bruit_moteur.finished.connect(Callable(bruit_moteur, "play"))
	bruit_moteur.play()
	bruit_moteur.volume_db = -40.0

	
	
	_flight_physics.setup(flight_config if flight_config else _create_default_config())
	_ground_detection.setup(self)
	for trail in _trails :
		trail.setup()
	_plane_animation.setup(get_node_or_null("plane_mesh"),  get_node_or_null("effect/helice"))
	_gravity_handler.setup(flight_config if flight_config else _create_default_config())
	
	for boost_visual in boost_visuals:
		boost_visual.config = flight_config
	
func _connect_signals():
	_ground_detection.landing_state_changed.connect(_on_landing_state_changed)
	_flight_physics.speed_updated.connect(_on_speed_updated)
	_flight_physics.boom_triggered.connect(_on_boom_triggered)

func _setup_initial_state():
	add_to_group("player")

# === BOUCLE PRINCIPALE ===
func _physics_process(delta: float) -> void:
	var input_data = _input_handler.get_input_data(delta, current_speed, is_grounded)
	
	if inv_pitch:
		input_data.pitch_input = -input_data.pitch_input
	
	var physics_result = _flight_physics.update_physics(input_data, delta, is_grounded, -basis.z, hydravion, basis.y)
	current_speed = physics_result.speed
	
	%UI_Boost.actualiser_ui_boost(physics_result.brake, physics_result.boost_index)
		
	
	_apply_movement(physics_result, delta)
	is_grounded = _ground_detection.update_grounded_state(velocity, delta)

	_plane_animation.update_animations(physics_result, is_grounded, delta)
	
	if brake != physics_result.brake:
		brake = physics_result.brake
	
	if physics_result.brake and !physics_result.boost:
		cam_follow._update_cam(delta, true)
	else:
		cam_follow._update_cam(delta, false)
		

	_update_debug_info()
	
	
	var collided := move_and_slide()
	if collided:
		var collision := get_last_slide_collision()
		if collision.get_collider().name == "Eau":
			hydravion = true
		else :
			hydravion = false
		if current_speed >= 200.0:
			if (to_local(collision.get_position()).normalized() + basis.z).length() <= 0.6:
				print("COLLISION")
				queue_free()
	
	
	for trail in _trails :
		if velocity.length() >= flight_config.trail_min_speed:
			if !trail.genere_trail:
				trail.genere_trail = true
		else :
			if trail.genere_trail:
				trail.genere_trail = false
				
		trail.update_trail(delta)
	
	for boost in boost_visuals:
		boost.update_boost_vfx(delta, physics_result.brake, physics_result.boost)
	
	bruit_vent.volume_db = clampf(-40.0 + velocity.length(), -40.0, 0.0)
	bruit_vent.pitch_scale = clampf(velocity.length(), 1.0, 3.0)
	bruit_moteur.volume_db = clampf(-40.0 + velocity.length(), -40.0, -10.0)
	bruit_moteur.pitch_scale = clampf(velocity.length(), 1.0, 2.0)

func _apply_movement(physics_result: PhysicsResult, delta: float):
	var water_state:= _water_handler.get_water_state(position.y)
	# Appliquer les rotations
	
	if water_state == "none":
		# Rotation verticale
		if !is_grounded or abs(physics_result.pitch_input) > 0:
			# Input rotation
			transform.basis = transform.basis.rotated(transform.basis.x, physics_result.pitch_input *  delta)
			# Gravity rotation
			if !is_grounded:
				transform.basis = basis.rotated(transform.basis.x, -_gravity_handler._get_angular_force(-basis.z, abs(velocity.x) + abs(velocity.z), basis.y) * delta)
		
		# Rotation horizontale, inversée quand l'avion est à l'envers
		if abs(rotation.x) > 0.5 * PI:
			transform.basis = transform.basis.rotated(Vector3.UP, -physics_result.turn_input * delta)
		else :
			transform.basis = transform.basis.rotated(Vector3.UP, physics_result.turn_input * delta)
		
		# On détermine la vélocité du moteur selon l'orientation de l'avion et la puissance du moteur
		basis = basis.orthonormalized()
		velocity = -transform.basis.z * current_speed
		
		# Si l'avion essaye et peut décoller, il s'élance en l'air
		if physics_result.should_takeoff:
			velocity.y += physics_result.takeoff_force * delta
		
		# Si il est en l'air la gravité s'applique
		if !is_grounded :
			velocity += _gravity_handler._get_linear_force(delta, -basis.z, velocity.length(), velocity.y)
		# Sinon elle se reset
		else :
			_gravity_handler.set_gravity_magnitude(0.0)
			
	elif water_state == "on_water":
		# Rotation verticale
		if !is_grounded or abs(physics_result.pitch_input) > 0:
			# Input rotation
			transform.basis = transform.basis.rotated(transform.basis.x, physics_result.pitch_input *  delta)
			
		# Rotation horizontale, inversée quand l'avion est à l'envers
		if abs(rotation.x) > 0.5 * PI:
			transform.basis = transform.basis.rotated(Vector3.UP, -physics_result.turn_input * delta)
		else :
			transform.basis = transform.basis.rotated(Vector3.UP, physics_result.turn_input * delta)
		
		# On détermine la vélocité du moteur selon l'orientation de l'avion et la puissance du moteur
		basis = basis.orthonormalized()
		velocity = -transform.basis.z * current_speed
		velocity -= velocity * _water_handler.frottements_survol
		
		# Si l'avion essaye et peut décoller, il s'élance en l'air
		if physics_result.should_takeoff:
			velocity.y += physics_result.takeoff_force * delta
		
		# On annule la gravité
		_gravity_handler.set_gravity_magnitude(0.0)
		
	elif water_state == "underwater":
		transform.basis = basis.rotated(transform.basis.x, _water_handler.get_angular_force(delta, -basis.z))
		velocity -= velocity * _water_handler.frottements_sous_marin
		velocity.y += _water_handler.get_linear_force(delta)

	
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
	if debug_ui:
		var texte_trails:= ""
		for trail in _trails :
			texte_trails += trail.get_debug_string() + "
"
		debug_ui.text = ( 
			_flight_physics.get_debug_string() + "\n" +
			texte_trails + "\n" +
			_gravity_handler.get_debug_string() + "\n" +
			_plane_animation.get_debug_string() + "\n" +
			"Velocite totale: %f.1" % velocity.length()
		)

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
