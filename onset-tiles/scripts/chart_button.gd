extends Button

var chart_path: String

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Global.current_song_directory = chart_path
	get_tree().change_scene_to_file("res://scenes/play_area.tscn")
