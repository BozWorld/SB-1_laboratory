extends CharacterBody3D

# Paramètres de vol plus arcade et réactifs
@export var min_flight_speed: float = 8.0
@export var max_flight_speed: float = 35.0
@export var turn_speed: float = 1.2          # Plus réactif
@export var pitch_speed: float = 2.0         # Plus réactif
@export var level_speed: float = 4.0         # Banking plus rapide
@export var throttle_delta: float = 35.0     # Accélération plus rapide
@export var acceleration: float = 8.0        # Transition plus rapide
@export var helice: Node3D
@export var helice_rotation_speed: float = 4.0

# Variables de vitesse simplifiées
var forward_speed: float = 0.0
var target_speed: float = 0.0
var previous_speed: float = 0.0

# États
var grounded: bool = false 
var was_grounded: bool = false  # Pour détecter le changement d'état
var turn_input: float = 0.0
var pitch_input: float = 0.0
var is_accelerating: bool = false
var acceleration_intensity: float = 0.0

@export var data: RichTextLabel
@export var mesh: MeshInstance3D

# TRAIL CONTROLS
@export var trail_node: trail3D  # Référence au trail3D
@export var min_trail_speed: float = 8.0

# NOUVEAU: Système de particules de moteur
@export var engine_particles_node: Node3D  # Point de spawn des particules
@export var engine_particle_scene: PackedScene  # Scène de la particule
var engine_particles: Array[Node3D] = []
var particle_spawn_timer: float = 0.0
@export var particle_spawn_rate: float = 0.08  # Plus rapide (était 0.1)
@export var max_engine_particles: int = 12  # Moins de particules (était 15)
@export var engine_particle_speed: float = 6.0  # Un peu plus rapide
@export var particle_cone_angle: float = 35.0  # Angle plus large pour plus de dispersion

func get_input(delta):
    # Throttle input
    var throttle_input = 0.0
    var throttle_change = 0.0
    
    if Input.is_action_pressed("throttle_up"):
        throttle_change = throttle_delta * delta
        throttle_input = 1.0
    elif Input.is_action_pressed("throttle_down"):
        throttle_change = -throttle_delta * delta
        throttle_input = -1.0
    
    # Appliquer le changement de throttle
    if throttle_change != 0:
        target_speed += throttle_change
        # CORRECTION: Permettre l'accélération au sol pour le décollage
        var speed_limit = 0.0  # Toujours permettre l'arrêt complet
        var max_limit = max_flight_speed
        # Au sol, permettre d'atteindre la vitesse de décollage
        if grounded:
            max_limit = min_flight_speed * 1.5  # 150% de la vitesse min pour décoller
        
        target_speed = clamp(target_speed, speed_limit, max_limit)
    
    # Détection de l'accélération améliorée
    var speed_change = forward_speed - previous_speed
    is_accelerating = (throttle_input > 0 and forward_speed < target_speed) or speed_change > 0.1
    acceleration_intensity = clamp(abs(speed_change) * 10.0, 0.0, 1.0)
    
    # Turn input
    turn_input = Input.get_axis("roll_right", "roll_left")
    if forward_speed <= 2.0:
        turn_input *= 0.3

    # Pitch input
    pitch_input = Input.get_axis("pitch_down", "pitch_up")
    
    # Empêcher le pitch au sol
    if grounded:
        pitch_input = 0.0
    elif forward_speed < 3.0:
        pitch_input *= 0.5

func update_trail_system():
    # Contrôler le trail basé sur la vitesse ET le fait d'être au sol
    if trail_node:
        var should_trail = forward_speed >= min_trail_speed and not grounded
        
        # Si on doit passer de actif à inactif, effacer le trail
        if trail_node._trainee_activee and not should_trail:
            trail_node.set_trail_enabled(false)
        # Si on doit passer de inactif à actif, activer le trail
        elif not trail_node._trainee_activee and should_trail:
            trail_node.set_trail_enabled(true)

func _ready():
    # Récupérer automatiquement le trail3D si pas assigné
    if not trail_node:
        trail_node = get_node_or_null("trail3D")
    
    # Récupérer automatiquement le point de spawn des particules
    if not engine_particles_node:
        # Essayer plusieurs noms possibles
        engine_particles_node = get_node_or_null("engine_spawn_point")
        if not engine_particles_node:
            engine_particles_node = get_node_or_null("GPUParticles3D")
        if not engine_particles_node:
            engine_particles_node = get_node_or_null("engine_particles")
        
        # Debug: afficher ce qui a été trouvé
        if engine_particles_node:
            print("Point de spawn des particules trouvé: ", engine_particles_node.name)
        else:
            print("Aucun point de spawn trouvé, utilisation de la position de l'avion")

func _physics_process(delta):
    previous_speed = forward_speed
    was_grounded = grounded
    
    get_input(delta)
    
    # Appliquer les rotations
    if not grounded or abs(pitch_input) > 0:
        transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
    
    transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
    
    # Bank when turning
    if grounded:
        mesh.rotation.z = 0
    else:
        mesh.rotation.z = lerpf(mesh.rotation.z, -turn_input, level_speed * delta)
    
    # Accélération/décélération
    forward_speed = lerpf(forward_speed, target_speed, acceleration * delta)
    
    # Movement is always forward
    velocity = -transform.basis.z * forward_speed
    
    # LOGIQUE D'ATTERRISSAGE ET DÉCOLLAGE CORRIGÉE
    var currently_on_floor = is_on_floor()
    
    if currently_on_floor:
        # Conditions pour être vraiment au sol
        var low_speed = forward_speed < min_flight_speed * 0.9
        var stable_contact = was_grounded
        var gentle_landing = velocity.y > -5.0
        
        # DÉCOLLAGE: Si on va assez vite, forcer le décollage
        if forward_speed >= min_flight_speed * 1.1:
            grounded = false
            # Ajouter une petite poussée vers le haut pour le décollage
            velocity.y += 3.0 * delta * (forward_speed / min_flight_speed)
        elif (low_speed or stable_contact or gentle_landing):
            grounded = true
            # Stabiliser l'avion au sol
            rotation.x = lerpf(rotation.x, 0.0, 5.0 * delta)
            rotation.z = lerpf(rotation.z, 0.0, 5.0 * delta)
            
            # Empêcher de s'enfoncer dans le sol
            if velocity.y < 0:
                velocity.y = 0
        else:
            grounded = false
    else:
        grounded = false
    
    # Hélice
    if helice:
        var spin = forward_speed * helice_rotation_speed * delta
        helice.rotate_z(spin)
    
    # Système de trail
    update_trail_system()
    
    # NOUVEAU: Système de particules de moteur
    update_engine_particles(delta)
    
    # Debug info (mise à jour)
    if data:
        data.text = "Vitesse: %.1f / %.1f\nAccélération: %s (%.1f)\nIntensité: %.2f\nTrail: %s\nParticules: %d\nAu sol: %s\nSol détecté: %s\nVitesse Y: %.2f" % [
            forward_speed, 
            target_speed,
            "OUI" if is_accelerating else "NON",
            acceleration,
            acceleration_intensity,
            "ACTIF" if trail_node and trail_node._trainee_activee else "INACTIF",
            engine_particles.size(),
            "OUI" if grounded else "NON",
            "OUI" if currently_on_floor else "NON",
            velocity.y
        ]

    move_and_slide()

func spawn_engine_particle():
    # Créer une particule simple si pas de scène définie
    var particle = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 0.06  # Encore plus petit
    sphere.height = 0.12  # Encore plus petit
    particle.mesh = sphere
    
    # Matériau cartoon transparent
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(1.0, 0.9, 0.7, 0.8)  # Jaune orangé transparent
    material.emission_enabled = true
    material.emission = Color(1.0, 0.8, 0.4) * 0.4
    material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
    particle.material_override = material
    
    # Position de départ (derrière l'avion) - CORRECTION: vérifier que le node est dans l'arbre
    if engine_particles_node and engine_particles_node.is_inside_tree():
        particle.global_position = engine_particles_node.global_position
    elif is_inside_tree():
        particle.global_position = global_position + transform.basis.z * 1.5
    else:
        # Fallback si aucun node n'est dans l'arbre
        particle.position = transform.origin + transform.basis.z * 1.5
    
    # NOUVEAU: Dispersion en cône SIMPLIFIÉE et plus visible
    var base_direction = transform.basis.z  # Direction vers l'arrière
    
    # Générer une dispersion aléatoire dans un cône
    var cone_radius = tan(deg_to_rad(particle_cone_angle))
    var random_x = randf_range(-cone_radius, cone_radius)
    var random_y = randf_range(-cone_radius, cone_radius)
    
    # Créer la direction dispersée
    var right = transform.basis.x
    var up = transform.basis.y
    var spread_vector = right * random_x + up * random_y
    var final_direction = (base_direction + spread_vector * 0.5).normalized()
    
    var particle_velocity = final_direction * engine_particle_speed * randf_range(0.7, 1.3)
    
    particle.set_meta("particle_velocity", particle_velocity)
    particle.set_meta("life", 0.0)
    particle.set_meta("max_life", randf_range(0.4, 0.8))  # DURÉE BEAUCOUP PLUS COURTE
    
    get_parent().add_child(particle)
    engine_particles.append(particle)

func update_engine_particles(delta):
    # Spawner des particules basé sur la vitesse
    var should_spawn = forward_speed > 2.0 and not grounded
    
    if should_spawn:
        particle_spawn_timer += delta
        var spawn_rate_adjusted = particle_spawn_rate / max(1.0, forward_speed / 15.0)  # Ajusté pour plus de particules à haute vitesse
        
        if particle_spawn_timer >= spawn_rate_adjusted and engine_particles.size() < max_engine_particles:
            spawn_engine_particle()
            particle_spawn_timer = 0.0
    else:
        # Si on ne devrait pas spawner, nettoyer graduellement
        if engine_particles.size() > 0 and forward_speed < 1.0:
            clear_engine_particles()
    
    # Mettre à jour les particules existantes
    var particles_to_remove = []
    
    for i in range(engine_particles.size()):
        var particle = engine_particles[i]
        if not is_instance_valid(particle):
            particles_to_remove.append(i)
            continue
        
        var life = particle.get_meta("life", 0.0)
        var max_life = particle.get_meta("max_life", 1.0)
        var particle_velocity = particle.get_meta("particle_velocity", Vector3.ZERO)
        
        life += delta
        particle.set_meta("life", life)
        
        # Mouvement de la particule avec légère décélération
        var speed_decay = 1.0 - (life / max_life) * 0.3  # Ralentit légèrement avec l'âge
        particle.global_position += particle_velocity * delta * speed_decay
        
        # Faire rétrécir et estomper la particule PLUS RAPIDEMENT
        var life_ratio = life / max_life
        var scale_factor = 1.0 - (life_ratio * 0.8)  # Rétrécit plus vite
        particle.scale = Vector3.ONE * scale_factor
        
        # Transparence qui diminue plus rapidement
        if particle.material_override:
            var mat = particle.material_override as StandardMaterial3D
            var alpha = (1.0 - life_ratio * life_ratio) * 0.8  # Courbe quadratique pour disparition plus rapide
            mat.albedo_color.a = alpha
        
        # Supprimer si trop vieille
        if life >= max_life:
            particles_to_remove.append(i)
    
    # Supprimer les particules expirées (en ordre inverse pour éviter les problèmes d'index)
    for i in range(particles_to_remove.size() - 1, -1, -1):
        var idx = particles_to_remove[i]
        if idx < engine_particles.size():
            var particle = engine_particles[idx]
            if is_instance_valid(particle):
                particle.queue_free()
            engine_particles.remove_at(idx)

func clear_engine_particles():
    """Nettoie toutes les particules de moteur"""
    for particle in engine_particles:
        if is_instance_valid(particle):
            particle.queue_free()
    engine_particles.clear()