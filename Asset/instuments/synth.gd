extends Resource
class_name Synth

@export var notes_octave1 : Array[AudioStream]
@export var notes_octave2 : Array[AudioStream]
@export var notes_octave3 : Array[AudioStream]
@export var notes_octave4 : Array[AudioStream]
@export var notes_octave5 : Array[AudioStream]



func accorder(octave : int, note : int):
	var octaves = [notes_octave1, notes_octave2, notes_octave3, notes_octave4, notes_octave5]
	var poctave = octaves[octave]
	return poctave[note]
