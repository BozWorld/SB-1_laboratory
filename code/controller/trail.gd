class_name trail3D extends MeshInstance3D

var _points = []
var _largeurs = []
var _longevites = []
var _directions = []  # NOUVEAU: pour des normales plus smooth

@export var _trainee_activee : bool = true

@export var _largeur_debut = 0.3  # Plus petit pour plus de réalisme
@export var _largeur_fin = 0.05   # Plus petit pour plus de réalisme
@export_range (0.5, 3) var _vitesse_grandissement : float = 1.5

@export var _precision_trainee : float = 0.15  # Plus smooth
@export var _duree_de_vie : float = 1.5  # Plus court pour éviter l'accumulation

@export var _couleur_debut : Color = Color(0.9, 0.9, 1.0, 0.8)  # Bleu clair
@export var _couleur_fin : Color = Color(0.5, 0.5, 0.8, 0.0)    # Disparition progressive
@export var _segments_circulaires : int = 6  # Moins de segments pour de meilleures perfs

var _ancienne_pos : Vector3

func _ready() -> void:
    _ancienne_pos = get_global_transform().origin
    mesh = ImmediateMesh.new()

func append_point():
    var current_pos = get_global_transform().origin
    var direction = Vector3.FORWARD
    
    # Calculer la direction si on a des points précédents
    if _points.size() > 0:
        direction = (current_pos - _points[-1]).normalized()
    
    _points.append(current_pos)
    _directions.append(direction)
    
    # Calculer les vecteurs perpendiculaires pour un trail rond
    var up = Vector3.UP
    if abs(direction.dot(up)) > 0.9:
        up = Vector3.RIGHT
    
    var right = direction.cross(up).normalized()
    up = right.cross(direction).normalized()
    
    _largeurs.append([right * _largeur_debut, up * _largeur_debut])
    _longevites.append(0.0)

func supprimer_point(i):
    _points.remove_at(i)
    _largeurs.remove_at(i)
    _longevites.remove_at(i)
    _directions.remove_at(i)

func _process(delta: float) -> void:
    # Toujours gérer la durée de vie des points existants
    var p = 0
    while p < _points.size():
        _longevites[p] += delta
        if _longevites[p] > _duree_de_vie:
            supprimer_point(p)
            # Ne pas incrémenter p car on a supprimé un élément
            continue
        p += 1
    
    # Ajouter un nouveau point seulement si le trail est activé
    if _trainee_activee and (_ancienne_pos - get_global_transform().origin).length() > _precision_trainee:
        append_point()
        _ancienne_pos = get_global_transform().origin
    
    # Reconstruire le mesh
    rebuild_mesh()

func rebuild_mesh():
    if _points.size() < 2:
        mesh.clear_surfaces()
        return
    
    mesh.clear_surfaces()
    mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
    
    # Créer un trail cylindrique smooth
    for i in range(_points.size() - 1):
        var t_current = float(i) / (_points.size() - 1.0)
        var t_next = float(i + 1) / (_points.size() - 1.0)
        
        var couleur_current = _couleur_debut.lerp(_couleur_fin, 1 - t_current)
        var couleur_next = _couleur_debut.lerp(_couleur_fin, 1 - t_next)
        
        var largeur_current = lerp(_largeur_debut, _largeur_fin, pow(t_current, _vitesse_grandissement))
        var largeur_next = lerp(_largeur_debut, _largeur_fin, pow(t_next, _vitesse_grandissement))
        
        # Créer un cylindre entre deux points
        create_cylinder_segment(i, largeur_current, largeur_next, couleur_current, couleur_next)
    
    mesh.surface_end()

func create_cylinder_segment(index: int, largeur1: float, largeur2: float, couleur1: Color, couleur2: Color):
    var pos1 = to_local(_points[index])
    var pos2 = to_local(_points[index + 1])
    
    var direction = (pos2 - pos1).normalized()
    var up = Vector3.UP
    if abs(direction.dot(up)) > 0.9:
        up = Vector3.RIGHT
    
    var right = direction.cross(up).normalized()
    up = right.cross(direction).normalized()
    
    # Créer les vertices du cylindre
    for seg in range(_segments_circulaires):
        var angle1 = float(seg) / _segments_circulaires * TAU
        var angle2 = float(seg + 1) / _segments_circulaires * TAU
        
        var offset1_1 = (right * cos(angle1) + up * sin(angle1)) * largeur1
        var offset1_2 = (right * cos(angle2) + up * sin(angle2)) * largeur1
        var offset2_1 = (right * cos(angle1) + up * sin(angle1)) * largeur2
        var offset2_2 = (right * cos(angle2) + up * sin(angle2)) * largeur2
        
        # Premier triangle
        mesh.surface_set_color(couleur1)
        mesh.surface_set_uv(Vector2(float(seg) / _segments_circulaires, 0))
        mesh.surface_add_vertex(pos1 + offset1_1)
        
        mesh.surface_set_color(couleur2)
        mesh.surface_set_uv(Vector2(float(seg) / _segments_circulaires, 1))
        mesh.surface_add_vertex(pos2 + offset2_1)
        
        mesh.surface_set_color(couleur1)
        mesh.surface_set_uv(Vector2(float(seg + 1) / _segments_circulaires, 0))
        mesh.surface_add_vertex(pos1 + offset1_2)
        
        # Deuxième triangle
        mesh.surface_set_color(couleur1)
        mesh.surface_set_uv(Vector2(float(seg + 1) / _segments_circulaires, 0))
        mesh.surface_add_vertex(pos1 + offset1_2)
        
        mesh.surface_set_color(couleur2)
        mesh.surface_set_uv(Vector2(float(seg) / _segments_circulaires, 1))
        mesh.surface_add_vertex(pos2 + offset2_1)
        
        mesh.surface_set_color(couleur2)
        mesh.surface_set_uv(Vector2(float(seg + 1) / _segments_circulaires, 1))
        mesh.surface_add_vertex(pos2 + offset2_2)

func clear_trail():
    """Force l'effacement complet du trail"""
    _points.clear()
    _largeurs.clear()
    _longevites.clear()
    _directions.clear()
    rebuild_mesh()

func set_trail_enabled(enabled: bool):
    """Active ou désactive le trail et l'efface si désactivé"""
    _trainee_activee = enabled
    if not enabled:
        clear_trail()