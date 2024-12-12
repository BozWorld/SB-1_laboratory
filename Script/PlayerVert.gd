extends SynthPlayer



func _init_stream():
	synth = preload("res://Asset/instuments/vert/synth_vert.tres")
	
	stream = synth.accorder(octave, note)
