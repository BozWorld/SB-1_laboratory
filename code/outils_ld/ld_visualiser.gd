@tool
extends Node3D

@onready var tracker = %tracker_ld
var memoire : Memoire

@export var play := false

var vitesse := 50.0

var index:= 0
var index_inter := 0.0

var periode := 0.0

func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#show()
		#if tracker:
			#if !memoire or tracker.memoire != memoire:
				#memoire = tracker.memoire
			#if play:
				#index += delta
				#if index >= memoire.duration:
					#index -= memoire.duration
				#progress_ratio = index / memoire.duration
	
	if Engine.is_editor_hint():
		show()
		if tracker:
			if !memoire or tracker.memoire != memoire:
				memoire = tracker.memoire
				periode = 1.0/tracker.frequence_track
			if play:
				index_inter += delta
				if index_inter >= tracker.frequence_track:
					index_inter -= tracker.frequence_track
					index += 1
					if index >= memoire.curve.point_count - 1:
						index = 0
				
				var last_point:= memoire.curve.get_point_position(index)
				var next_point:= memoire.curve.get_point_position(index + 1)
				var approx_point:= last_point.lerp(next_point, index_inter * periode)
				var accurate_offset:= memoire.curve.get_closest_offset(approx_point)
				var accurate_point:= memoire.curve.sample_baked_with_rotation(accurate_offset)
				transform = accurate_point
	
	else :
		hide()
