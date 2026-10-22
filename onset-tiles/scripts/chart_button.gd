extends Button

signal play

var chart_path: String

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Global.current_song_directory = chart_path
	play.emit()
