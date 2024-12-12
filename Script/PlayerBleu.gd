extends SynthPlayer



func _init_stream():
	synth = preload("res://Asset/instuments/bleu/synth_bleu.tres")
	
	stream = synth.accorder(octave, note)
