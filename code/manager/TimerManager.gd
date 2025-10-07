extends Node
class_name TimerManager

signal timer_updated(current_time: float)

var _current_time: float = 0.0
var _is_running: bool = false

func start_timer():
    _is_running = true
    _current_time = 0.0
    print("Timer démarré !")

func stop_timer() -> float:
    _is_running = false
    print("Timer arrêté ! Temps final: ", format_time(_current_time))
    return _current_time

func update_timer(delta: float):
    if _is_running:
        _current_time += delta
        timer_updated.emit(_current_time)

func reset_timer():
    _current_time = 0.0 
    _is_running = false
    print("Timer remis à zéro")

func get_current_time() -> float:
    return _current_time

func format_time(time_seconds: float) -> String:
    var minutes = int(time_seconds) / 60
    var seconds = int(time_seconds) % 60
    var miliseconds = int((time_seconds - int(time_seconds)) * 100)
    return "%02d:%02d.%02d" % [minutes,seconds,miliseconds]

