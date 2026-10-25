extends CanvasLayer

@onready var screens: CanvasLayer = $Screens
@onready var song_list: VBoxContainer = $"Screens/Screen 1/ScrollContainer/VBoxContainer"
@onready var backgrounds: CanvasLayer = $Backgrounds
@onready var import_dialog: FileDialog = $"Import Dialog"

@export var chart_button_scene: PackedScene

const screen_coords = [720, 0, -720]
const pc_song_folder = "res://songs/"
const play_area_scene = preload("res://scenes/play_area.tscn")

func _ready() -> void:
	import_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	import_dialog.use_native_dialog = true
	import_dialog.access = FileDialog.ACCESS_FILESYSTEM
	Global.score = 0
	Global.tiles_missed = 0
	load_song_names()

func _process(delta: float) -> void:
	pass
	
func get_songs_path() -> String:
	if OS.get_name() == "Android":
		return Global.song_path
	return pc_song_folder
	
func load_song_names():
	for child in song_list.get_children():
		child.queue_free()
	var song_dir = DirAccess.open(get_songs_path())
	if song_dir == null:
		return
		
	song_dir.list_dir_begin()
	var folder_name = song_dir.get_next()
	
	while folder_name != "":
		var full_path = get_songs_path() + folder_name
		var settings_path = full_path + "/settings.json"
		
		if FileAccess.file_exists(settings_path):
			var file = FileAccess.open(settings_path, FileAccess.READ)
			var json = JSON.new()
			var error = json.parse(file.get_as_text())
			file.close()
			
			if error == OK and json.data is Dictionary:
				var settings: Dictionary = json.data
				var song_data: Dictionary = settings["song_data"]
				var user_data: Dictionary = settings["user_data"]
				var button = chart_button_scene.instantiate()
				button.title = str(song_data.get("title", folder_name))
				button.artist = str(song_data.get("artist", "Unknown"))
				button.bpm = song_data.get("bpm", -1)
				button.high_score = user_data.get("score", 0)
				button.chart_path = full_path
				var cover_file_path = full_path.path_join("cover.png")
				if FileAccess.file_exists(cover_file_path):
					button.cover_texture = load(cover_file_path)
				button.play.connect(transition_to_play_area)
				song_list.add_child(button)
				
		folder_name = song_dir.get_next()
	song_dir.list_dir_end()

func _on_new_button_pressed() -> void:
	slide_screen(screen_coords[2])

func _on_back_button_pressed() -> void:
	slide_screen(screen_coords[1])

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/play_area.tscn")
	
func slide_screen(screen):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(screens, "offset", Vector2(screen, 0), 0.2)
	
func transition_to_play_area():
	slide_screen(screen_coords[0])
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(backgrounds, "offset", Vector2(screen_coords[0], 0), 0.2)
	await get_tree().create_timer(0.3).timeout
	var play_area = play_area_scene.instantiate()
	get_tree().root.add_child(play_area)
	queue_free()

func _on_import_button_pressed() -> void:
	import_dialog.popup_centered_clamped(Vector2i(600, 400))

func _on_folder_selected(source_dir_path: String) -> void:
	print("Selected source path: ", source_dir_path)
	source_dir_path = "/" + fix_content_android(source_dir_path)
	print("Final selected path: ", source_dir_path)
	var source_dir = DirAccess.open(source_dir_path)
	
	if source_dir:
		print("Successfully opened source directory.")
		source_dir.list_dir_begin()
		var folder_name = source_dir.get_next()
		
		while folder_name != "":
			print("Found item in root -> ", folder_name, " | Is dir: ", source_dir.current_is_dir())
			if source_dir.current_is_dir() and !folder_name.begins_with("."):
				var subfolder_path = source_dir_path + "/" + folder_name
				var target_path = get_songs_path() + folder_name
				print("Copying folder from ", subfolder_path, " to ", target_path)
				copy_songs(subfolder_path, target_path)
			folder_name = source_dir.get_next()
		source_dir.list_dir_end()
		
		load_song_names()
	else:
		print("Failed to open source directory at path: ", source_dir_path)
		
func copy_songs(from_path: String, to_path: String) -> void:
	var dir = DirAccess.open(from_path)
	if dir:
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		
		while folder_name != "":
			if !folder_name.begins_with("."):
				var folder_from = from_path + "/" + folder_name
				var folder_to = to_path + "/" + folder_name
				
				if dir.current_is_dir():
					if has_required_files(folder_from):
						var mk_err = DirAccess.make_dir_recursive_absolute(folder_to)
						print("Making target dir result for ", folder_to, " | Error code: ", mk_err)
						copy_songs(folder_from, folder_to)
				else:
					if folder_name in ["settings.json", "lanes.lrc", "song.mp3", "cover.png"]:
						var copy_err = DirAccess.copy_absolute(folder_from, folder_to)
						print("Copying file ", folder_name, " | Error code: ", copy_err)
			folder_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open subfolder for copying: ", from_path)
		
func fix_content_android(path: String) -> String:
	if path.begins_with("content://"):
		if "primary%3A" in path:
			var selected_folder = path.split("primary%3A")[1]
			if "?" in selected_folder:
				selected_folder = selected_folder.split("?")[0]
			return "storage/emulated/0/" + selected_folder.uri_decode()
		elif "primary:" in path:
			var selected_folder = path.split("primary:")[1]
			if "?" in selected_folder:
				selected_folder = selected_folder.split("?")[0]
			return "storage/emulated/0/" + selected_folder.uri_decode()
	return path

func has_required_files(path: String) -> bool:
	var required_files = ["settings.json", "lanes.lrc", "song.mp3", "cover.png"]
	for file in required_files:
		if !FileAccess.file_exists(path.path_join(file)):
			return false
	return true
