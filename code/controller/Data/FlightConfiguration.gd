extends Resource
class_name FlightConfiguration

@export_category("Vitesse")
@export var min_flight_speed: float = 8.0
@export var max_flight_speed: float = 35.0
@export var boost_strength: float = 50.0
@export var boost_add_maxs: float = 100.0
@export var boost_density: float = 1.0
@export var throttle_delta: float = 35.0 # m/s de variation de target_speed
@export var acceleration: float = 8.0 #suivi de forward_speed vers target_speed
@export_category("Contrôle")
@export var turn_speed: float = 1.2
@export var pitch_speed: float = 2.0
@export_category("Notes")
@export_multiline var notes: String = "throttle_delta est la variation de target_speed en m/s\nacceleration est la vitesse de suivi de forward_speed vers target_speed"
