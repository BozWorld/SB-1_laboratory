@tool
extends EditorScript


func _run():
	for node in get_all_children(get_scene()):
		if node is Etoile:
			node.frequence = randi_range(0,12)
			
			#var capital_couleur = randi_range(0,600)
			var rouge : float = randf()
			var bleu : float = randf()
			var vert : float = randf()
			
			#while capital_couleur > 0:
				#rouge += randi_range(0,clampi(capital_couleur, 0, 255))
				#capital_couleur -= rouge
				#bleu += randi_range(0, clampi(capital_couleur, 0, 255))
				#capital_couleur -= bleu
				#vert += randi_range(0,clampi(capital_couleur,0,255))
				#capital_couleur -= vert
			
			node.couleur = Color(rouge, vert, bleu)



func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
