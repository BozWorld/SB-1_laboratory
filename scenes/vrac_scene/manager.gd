extends Node3D

@export var score_label: RichTextLabel

# Variables du timer
var game_timer: float = 0.0
var is_timer_running: bool = false
var game_started: bool = false

func _ready():
    # Initialiser l'affichage
    update_score_display()

func _physics_process(delta: float) -> void:
    # Démarrer automatiquement le timer au premier frame
    if not game_started:
        start_timer()
        game_started = true
    
    # Mettre à jour le timer si il tourne
    if is_timer_running:
        game_timer += delta
        update_score_display()

func start_timer():
    """Démarre le timer de jeu"""
    is_timer_running = true
    game_timer = 0.0
    print("Timer démarré !")

func stop_timer():
    """Arrête le timer de jeu"""
    is_timer_running = false
    print("Timer arrêté ! Temps final: ", format_time(game_timer))

func reset_timer():
    """Remet le timer à zéro"""
    game_timer = 0.0
    is_timer_running = false
    update_score_display()
    print("Timer remis à zéro")

func format_time(time_seconds: float) -> String:
    """Formate le temps en format MM:SS.ms"""
    var minutes = int(time_seconds) / 60
    var seconds = int(time_seconds) % 60
    var milliseconds = int((time_seconds - int(time_seconds)) * 100)
    
    return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func update_score_display():
    """Met à jour l'affichage du score"""
    if score_label:
        var formatted_time = format_time(game_timer)
        score_label.text = "Your current score is: " + formatted_time

func get_current_time() -> float:
    """Retourne le temps actuel pour d'autres scripts"""
    return game_timer

func _on_static_body_3d_body_entered(body: CharacterBody3D) -> void:
    print("Collision with body entered: ", body.name)
    
    # Exemple: Arrêter le timer quand le joueur atteint la ligne d'arrivée
    if body.name == "Player" or body.name.contains("plane"):
        stop_timer()
        # Optionnel: Afficher le temps final
        if score_label:
            score_label.text = "FINISH! Final time: " + format_time(game_timer)
