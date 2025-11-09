extends Node
class_name UIManager

@export var score_label: RichTextLabel
@export var score_control: Control
@export var final_score_label: RichTextLabel
@export var final_score_control: Control


@export var data_control: Control
@export var rings_label: RichTextLabel
@export var landing_label: RichTextLabel

var _totals_rings := 0
var _passed_rings := 0

var _total_bonus_rings:= 0
var _passed_bonus_rings:= 0

var _landing_avail:= false



func update_score_display(current_time: float, score: float):
	if score_label:
		var formatted_time = _format_time(current_time)
		score_label.text = "Your current time is: " + formatted_time + "\n" +"Your current score is: %f" % score


func show_final_score(final_time: float):
	if score_control:
		score_control.hide()
	if final_score_control and final_score_label:
		final_score_control.show()
		final_score_label.text = "Your final score is: " + _format_time(final_time) + "!!! "

func hide_final_score():
	if final_score_control:
		final_score_control.hide()

func set_total_rings(total: int, bonus_total: int):
	_totals_rings = max(total,0)
	_total_bonus_rings = max(bonus_total, 0)
	_refresh_hud()

func update_rings(passed: int):
	_passed_rings = clamp(passed,0,_totals_rings)
	_refresh_hud()

func update_bonus_rings(passed: int):
	_passed_bonus_rings = clamp(passed, 0, _total_bonus_rings)
	_refresh_hud()

func set_landing_available(available: bool):
	_landing_avail = available
	_refresh_hud()

func _refresh_hud():
	if rings_label:
		rings_label.text = "Rings: %d / %d" % [_passed_rings,_totals_rings] + "\n" + "Bonus Rings: %d / %d" % [_passed_bonus_rings, _total_bonus_rings]
	if landing_label:
		landing_label.text = "Landing: " + ("Available" if _landing_avail else "Not Available")
		print("Landing status updated: ", landing_label.text)

func _format_time(time_seconds: float) -> String:
	var minutes = int(time_seconds / 60)
	var seconds = int(time_seconds) % 60
	var milliseconds = int((time_seconds - int(time_seconds)) * 100)
	return "%02d:%02d.%02d " % [minutes,seconds,milliseconds]
