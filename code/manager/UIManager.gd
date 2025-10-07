extends Node
class_name UIManager

@export var score_label: RichTextLabel
@export var score_control: Control
@export var final_score_label: RichTextLabel
@export var final_score_control: Control

func update_score_display(current_time: float):
    if score_label:
        var formatted_time = _format_time(current_time)
        score_label.text = "your current score is:" + formatted_time

func show_final_score(final_time: float):
    if score_control:
        score_control.hide()
    if final_score_control and final_score_label:
        final_score_control.show()
        final_score_label.text = "Your final score is: " + _format_time(final_time) + "!!! "

func hide_final_score():
    if final_score_control:
        final_score_control.hide()

func _format_time(time_seconds: float) -> String:
    var minutes = int(time_seconds / 60)
    var seconds = int(time_seconds) % 60
    var milliseconds = int((time_seconds - int(time_seconds)) * 100)
    return "%02d:%02d.%02d" % [minutes,seconds,milliseconds]