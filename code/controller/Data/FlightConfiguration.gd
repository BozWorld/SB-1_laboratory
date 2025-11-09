extends Resource
class_name FlightConfiguration

@export_category("Vitesse")
@export var min_flight_speed: float = 8.0
@export var max_flight_speed: float = 35.0
@export var throttle_delta: float = 35.0 # m/s de variation de target_speed
@export var acceleration: float = 8.0 #suivi de forward_speed vers target_speed
@export_category("Boost")
## Courbe qui définit la jauge de charge du boost en fonction du temps de charge (la valeur défini en maximum du domaine détermine le temps de charge maximum)
@export var boost_charge: Curve
## Lorsque le frein est laché et le boost pas encore consommé, définit le taux de perte de charge
@export var boost_charge_loss:= 0.7
## Courbe qui définit, la puissance du boost à partir de son activation, et sur une durée qui dépend de la charge obtenue
@export var boost_grow: Curve
## Puissance du boost au summum de la courbe au dessus
@export_range(0.0, 500.0, 0.5,"or_greater") var boost_peak:= 100.0
## Durée du boost lorsque la charge vaut 1
@export var boost_max_duration:= 1.0:
	set(value):
		boost_max_duration = value
		inv_boost_max_duration = 1.0/value
var inv_boost_max_duration := 1.0
## Durée à partir de la fin du boost après laquelle la vitesse du boost est totalement perdue
@export var boost_momentum:= 4.4:
	set(value):
		boost_momentum = value
		inv_boost_momentum = 1.0/value
var inv_boost_momentum := 1.0
@export_category("Contrôle")
@export var turn_speed: float = 1.2
@export var pitch_speed: float = 2.0
## Modificateur (multiplication) de la vitesse de rotation en freinant
@export var brake_rotation_mod:= 2.0
@export_category("Gravité")
## Perte d'energie par frame de la gravité accumulée
@export var energy_loss:= 0.01
## Puissance de mouvement de la gravité
@export_range(0.0,100.0,0.1,"or_greater") var linear_strength:= 44.4
## Puissance de rotation de la gravité
@export_range(0.0,1.0,0.01,"or_greater") var angular_strength:= 0.1
## Vitesse à atteindre pour planer sans chute
@export_range(0.0,100.0,0.5) var speed_to_glide := 30.0
@export_category("Effets")
## Vitesse à atteindre pour que les trails apparaissent
@export var trail_min_speed:= 15.0
@export_category("Notes")
@export_multiline var notes: String = "throttle_delta est la variation de target_speed en m/s\nacceleration est la vitesse de suivi de forward_speed vers target_speed"
