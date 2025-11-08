extends Resource
class_name FlightConfiguration

@export_category("Vitesse")
@export var min_flight_speed: float = 8.0
@export var max_flight_speed: float = 35.0
@export var throttle_delta: float = 35.0 # m/s de variation de target_speed
@export var acceleration: float = 8.0 #suivi de forward_speed vers target_speed
@export_category("Boost")
@export var boost_grow: Curve
@export_range(0.0, 500.0, 0.5,"or_greater") var boost_peak:= 100.0
@export var boost_max_duration:= 1.0:
	set(value):
		boost_max_duration = value
		inv_boost_max_duration = 1.0/value
var inv_boost_max_duration := 1.0
@export var boost_charge: Curve
@export var boost_charge_loss:= 0.7
@export var boost_momentum:= 4.4:
	set(value):
		boost_momentum = value
		inv_boost_momentum = 1.0/value
var inv_boost_momentum := 1.0
@export_category("Contrôle")
@export var turn_speed: float = 1.2
@export var pitch_speed: float = 2.0
@export var brake_rotation_mod:= 2.0
@export_category("Gravité")
@export var energy_loss:= 0.01
@export_range(0.0,100.0,0.1,"or_greater") var linear_strength:= 44.4
@export_range(0.0,1.0,0.01,"or_greater") var angular_strength:= 0.1
@export_range(0.0,100.0,0.5) var speed_to_glide := 30.0
@export_category("Effets")
@export var trail_min_speed:= 15.0
@export_category("Notes")
@export_multiline var notes: String = "throttle_delta est la variation de target_speed en m/s\nacceleration est la vitesse de suivi de forward_speed vers target_speed"
