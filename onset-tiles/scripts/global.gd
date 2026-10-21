extends Node

var song_settings: Dictionary
var current_song_directory: String
var global_error: String
var score: int

func _ready() -> void:
	create_song_folder()

func _process(delta: float) -> void:
	pass

func load_song_settings(directory: String) -> Dictionary:
	var path = directory.path_join("settings.json")
	
	if !FileAccess.file_exists(path):
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error == OK:
		return json.data
	return {}
	
func load_lrc(directory: String):
	var path = directory.path_join("lanes.lrc")
	var tiles = []
	
	if !FileAccess.file_exists(path):
		return tiles
		
	var file = FileAccess.open(path, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "" or !line.begins_with("["):
			continue
			
		var parts = line.split("] ")
		if parts.size() < 2:
			continue
			
		var time_str = parts[0].trim_prefix("[")
		var lane = int(parts[1])
		var time_split = time_str.split(":")
		var minutes = int(time_split[0])
		var seconds = float(time_split[1])
		var timestamp = (minutes * 60.0) + seconds
		
		tiles.append({"time": timestamp, "lane": lane})
	
	file.close()
	return tiles
	
func create_song_folder():
	if OS.get_name() == "Android":
		var path = "storage/emulated/0/Android/data/com.sadplayer652523.onset/files/songs"
		var error = DirAccess.make_dir_recursive_absolute(path)
		
		if error == OK or error == ERR_ALREADY_EXISTS:
			print("Song folder created or already exists: " + path)
		else:
			print("Song folder not created: " + path + " | error: " + error)
			global_error = "Error: " + error + "\nException: " + path
			get_tree().change_scene_to_file("res://scenes/game_crash.tscn")
			
