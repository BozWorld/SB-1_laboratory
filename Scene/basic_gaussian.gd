extends Node2D

var points := []
var ecart_type := 30.0
var color := Color(1, 0, 0, 0.05) # couleur rouge avec alpha faible
func _process(_delta):
	var x = randfn(get_viewport().get_visible_rect().size.x/2, ecart_type)
	var y = randfn(get_viewport().get_visible_rect().size.y/2, ecart_type)
	var hue = randfn(0.1,0.05)
	var saturation = randfn(0.2, 0.1)
	var value = randfn(0.4, 0.1)
	color = Color.from_hsv(hue, saturation, value, 0.05)
	points.append({
		"pos": Vector2(x, y),
		"color": color
	})
	queue_redraw()

func _draw():
	for point in points:
		draw_circle(point.pos, 8, point.color) # alpha faible pour l'accumulation


func _on_h_slider_value_changed(value:float) -> void:
	ecart_type = value
