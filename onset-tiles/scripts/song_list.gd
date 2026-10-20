extends CanvasLayer

@onready var screens: CanvasLayer = $Screens
@onready var song_list: VBoxContainer = $"Screens/Screen 1/ScrollContainer/VBoxContainer"

@export var chart_button_scene: PackedScene

const screen_coords = [0, -720]

func _ready() -> void:
	load_song_names()

func _process(delta: float) -> void:
	pass
	
func load_song_names():
	var song_dir = DirAccess.open("res://songs")
	if song_dir == null:
		return
		
	song_dir.list_dir_begin()
	var folder_name = song_dir.get_next()
	
	while folder_name != "":
		var full_path = "res://songs/" + folder_name
		var settings_path = full_path + "/settings.json"
		
		if FileAccess.file_exists(settings_path):
			var file = FileAccess.open(settings_path, FileAccess.READ)
			var json = JSON.new()
			var error = json.parse(file.get_as_text())
			file.close()
			
			if error == OK and json.data is Dictionary:
				var settings: Dictionary = json.data
				var button = chart_button_scene.instantiate()
				button.text = str(settings.get("title", folder_name))
				button.chart_path = full_path
				song_list.add_child(button)
				
		folder_name = song_dir.get_next()
	song_dir.list_dir_end()

func _on_new_button_pressed() -> void:
	screens.offset.x = screen_coords[1]

func _on_back_button_pressed() -> void:
	screens.offset.x = screen_coords[0]

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/play_area.tscn")
