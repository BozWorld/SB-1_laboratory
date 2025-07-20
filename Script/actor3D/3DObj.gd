extends MeshInstance3D

@export var velocity : Vector3
@export var acceleration: Vector3
@export var force : Vector3
@export var gravity : Vector3
@export var collision_type: CollisionType = CollisionType.STATIC_BODY # Type de collision à générer
@export var collision_shape_type: ShapeType = ShapeType.CONVEX # Type de forme de collision
var collision_body: PhysicsBody3D # Référence au corps de collision généré
var collision_shape: CollisionShape3D # Référence à la forme de collision générée
var accTo: float = 0.8
var dir: Vector3
@export var mass: float
@export var c: float

enum CollisionType {
	STATIC_BODY,    # Objet statique (ne bouge pas)
	RIGID_BODY,     # Objet physique (gère automatiquement la physique)
	CHARACTER_BODY  # Objet contrôlé manuellement
}

enum ShapeType {
	CONVEX,         # Forme convexe (plus rapide)
	TRIMESH,        # Forme précise (plus lent)
	BOX,            # Boîte simple
	SPHERE          # Sphère simple
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# S'assurer que les valeurs par défaut sont correctes
	if mass <= 0:
		mass = 1.0
	if c <= 0:
		c = 0.1
	
	# Initialiser gravity si pas défini
	if gravity == Vector3.ZERO:
		gravity = Vector3(0, -9.8, 0)
	
	generate_collision()
	
	# Debug : afficher l'état initial
	print("Objet initialisé - Type: ", collision_type, ", Masse: ", mass, ", Friction: ", c)

# Génère automatiquement les collisions basées sur le mesh
func generate_collision():
	if not mesh:
		print("Aucun mesh assigné, impossible de générer les collisions")
		return
	
	# Créer le corps de collision selon le type choisi
	match collision_type:
		CollisionType.STATIC_BODY:
			collision_body = StaticBody3D.new()
		CollisionType.RIGID_BODY:
			collision_body = RigidBody3D.new()
			if mass > 0:
				(collision_body as RigidBody3D).mass = mass
			# Pour RigidBody3D, le mesh doit être enfant du corps de collision
			var parent = get_parent()
			if parent:
				parent.remove_child(self)
				collision_body.add_child(self)
				parent.add_child(collision_body)
				position = Vector3.ZERO # Reset la position relative
		CollisionType.CHARACTER_BODY:
			collision_body = CharacterBody3D.new()
	
	# Pour Static et Character, ajouter le corps comme enfant
	if collision_type != CollisionType.RIGID_BODY:
		add_child(collision_body)
	
	# Créer la forme de collision
	collision_shape = CollisionShape3D.new()
	var shape: Shape3D
	
	match collision_shape_type:
		ShapeType.CONVEX:
			shape = mesh.create_convex_shape()
		ShapeType.TRIMESH:
			shape = mesh.create_trimesh_shape()
		ShapeType.BOX:
			var aabb = mesh.get_aabb()
			shape = BoxShape3D.new()
			(shape as BoxShape3D).size = aabb.size
		ShapeType.SPHERE:
			var aabb = mesh.get_aabb()
			shape = SphereShape3D.new()
			(shape as SphereShape3D).radius = max(aabb.size.x, aabb.size.y, aabb.size.z) / 2.0
	
	collision_shape.shape = shape
	collision_body.add_child(collision_shape)
	
	print("Collision générée: ", collision_type, " avec forme: ", collision_shape_type)

# Fonction pour changer le type de collision dynamiquement
func change_collision_type(new_type: CollisionType):
	if collision_body:
		collision_body.queue_free()
		collision_body = null
		collision_shape = null
	
	collision_type = new_type
	generate_collision()

# Fonction pour changer le type de forme de collision
func change_collision_shape(new_shape: ShapeType):
	collision_shape_type = new_shape
	if collision_shape and collision_shape.shape:
		var shape: Shape3D
		
		match collision_shape_type:
			ShapeType.CONVEX:
				shape = mesh.create_convex_shape()
			ShapeType.TRIMESH:
				shape = mesh.create_trimesh_shape()
			ShapeType.BOX:
				var aabb = mesh.get_aabb()
				shape = BoxShape3D.new()
				(shape as BoxShape3D).size = aabb.size
			ShapeType.SPHERE:
				var aabb = mesh.get_aabb()
				shape = SphereShape3D.new()
				(shape as SphereShape3D).radius = max(aabb.size.x, aabb.size.y, aabb.size.z) / 2.0
		
		collision_shape.shape = shape
		print("Forme de collision changée vers: ", collision_shape_type)

# Fonction pour obtenir le corps de collision (utile pour connecter des signaux)
func get_collision_body() -> PhysicsBody3D:
	return collision_body

# Fonction de test pour vérifier que l'objet bouge
func test_movement():
	print("Test de mouvement...")
	# Appliquer une force de test
	force = Vector3(10, 0, 0)
	print("Force appliquée: ", force)

# Fonction pour reset l'objet
func reset_object():
	velocity = Vector3.ZERO
	acceleration = Vector3.ZERO
	force = Vector3.ZERO
	position = Vector3.ZERO
	if collision_body:
		collision_body.global_position = Vector3.ZERO
		if collision_body is RigidBody3D:
			var rigid = collision_body as RigidBody3D
			rigid.linear_velocity = Vector3.ZERO
			rigid.angular_velocity = Vector3.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Seulement appliquer la physique si on utilise CHARACTER_BODY ou si on contrôle manuellement
	if collision_type == CollisionType.CHARACTER_BODY or collision_type == CollisionType.STATIC_BODY:
		var friction = (-velocity).normalized() * c
		applyForces(friction)
		applyForces(force)
		applyForces(gravity)
		setVelocity(delta)
		acceleration = Vector3.ZERO
		checkEdgesBounce()
	elif collision_type == CollisionType.RIGID_BODY and collision_body:
		# Pour RigidBody3D, on laisse la physique de Godot gérer le mouvement
		# Mais on peut encore appliquer des forces si nécessaire
		var rigid_body = collision_body as RigidBody3D
		if rigid_body:
			# Appliquer des forces au RigidBody au lieu de manipuler directement la position
			rigid_body.apply_central_force(force + gravity)
			# Synchroniser la position du MeshInstance3D avec le RigidBody
			global_position = rigid_body.global_position
			global_rotation = rigid_body.global_rotation

func getDirection():
	dir = get_viewport().get_global_mouse_position() - Vector2(position.x,position.y)
	dir = dir.normalized()

func setVelocity(delta):
	velocity += acceleration * delta
	limitVelocity(Vector3(-300,-300,-300),Vector3(300,300,300))
	
	# Appliquer le mouvement selon le type de collision
	if collision_type == CollisionType.CHARACTER_BODY and collision_body:
		# Pour CharacterBody3D, utiliser move_and_slide()
		var char_body = collision_body as CharacterBody3D
		if char_body:
			char_body.velocity = velocity
			char_body.move_and_slide()
			# Synchroniser la position du MeshInstance3D
			global_position = char_body.global_position
	elif collision_type == CollisionType.STATIC_BODY:
		# Pour StaticBody ou contrôle manuel, bouger directement
		position += velocity * delta
		# Synchroniser le corps de collision si il existe
		if collision_body:
			collision_body.global_position = global_position

# permet de récupéré la force relative a l'objet
func applyForces(applied_force: Vector3):
	var f = Vector3(applied_force/mass)
	acceleration += f 
	
func limitVelocity(v1: Vector3,v2: Vector3):
	velocity = velocity.clamp(v1,v2)

func add(v1:Vector3,v2:Vector3):
	var v3 = Vector3(v1.x + v2.x, v1.y + v2.y,v1.z + v2.z)
	return v3



func checkEdgesBounce():
	# Utiliser la collision générée automatiquement
	if collision_shape and collision_shape.shape:
		var shape = collision_shape.shape
		var bounds: Vector3
		
		# Obtenir les limites selon le type de forme
		if shape is BoxShape3D:
			bounds = (shape as BoxShape3D).size
		elif shape is SphereShape3D:
			var radius = (shape as SphereShape3D).radius
			bounds = Vector3(radius * 2, radius * 2, radius * 2)
		else:
			# Pour les autres formes, utiliser l'AABB du mesh
			bounds = mesh.get_aabb().size if mesh else Vector3(1, 1, 1)
		
		# Vérifier les collisions avec les bords
		if position.y > bounds.y/2:
			velocity.y *= -1
			position.y = bounds.y/2
		if position.x > bounds.x/2:
			position.x = bounds.x/2
			velocity.x *= -1
		if position.x < -bounds.x/2:
			position.x = -bounds.x/2
			velocity.x *= -1
		if position.y < -bounds.y/2:
			position.y = -bounds.y/2
			velocity.y *= -1

func _on_vel_timer_timeout():
	print ( velocity )

func checkEdges():
	if ((position.x > (get_viewport().get_visible_rect().size.x)/2)):
		position.x = 0
		velocity.x *= -1
	elif position.x < 0:
		position.x = get_viewport().get_visible_rect().size.x
	if position.y > get_viewport().get_visible_rect().size.y:
		position.y = 0
	elif position.y < 0:
		position.y = get_viewport().get_visible_rect().size.y
