extends SynthPlayer


func _init_stream():
	synth = preload("res://Asset/instuments/rouge/synth_rouge.tres")
	
	stream = synth.accorder(octave, note)
