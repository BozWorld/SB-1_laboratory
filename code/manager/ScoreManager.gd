extends RefCounted
class_name ScoreManager

var total_score:= 0.0

func add_score(score):
	total_score += score

func get_debug_string():
	return "Score: %f.1" % total_score
