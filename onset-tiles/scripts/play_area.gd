extends CanvasLayer

@export var tile_scene: PackedScene
var song_list_scene: PackedScene

@onready var score_text: RichTextLabel = %"Score Text"
@onready var hit_line: ColorRect = $"Background Layer/Hit Line"
@onready var audio_player: AudioStreamPlayer = $Audio
@onready var tiles_scene: CanvasLayer = $"Tiles Layer"
@onready var hit_line_collision: Area2D = $"Background Layer/Hit Line/Hit Line Area2D"
@onready var pause_screen: CanvasLayer = $"Pause Screen"
@onready var background_layer: CanvasLayer = $"Background Layer"
@onready var ui_layer: CanvasLayer = $UI

var chart = []
var next_tile = 0
var song_time = 0.0
var playing = false

var song_list

func play_song(directory: String) -> void:
	var audio_path = directory + "/song.mp3"
	var audio: AudioStream = AudioStreamMP3.load_from_file(audio_path)
	if audio:
		audio_player.stream = audio
		audio_player.play()
	else:
		print("Failed to load song: " + audio_path)
		Global.global_error = "Error: Failed to load song\nException: " + audio_path
		get_tree().change_scene_to_file("res://scenes/game_crash.tscn")

func start_chart(directory: String) -> void:
	chart = Global.load_lrc(directory)
	chart.sort_custom(func(a, b): return a["time"] < b["time"])
	play_song(directory)
	next_tile = 0
	song_time = 0
	playing = true

func _ready() -> void:
	song_list_scene = load("res://scenes/menus/song_list.tscn")
	song_list = song_list_scene.instantiate()
	get_tree().root.add_child(song_list)
	Global.hit_line_position_y = hit_line.position.y
	Global.song_settings = Global.load_song_settings(Global.current_song_directory)
	start_chart(Global.current_song_directory)

func _process(delta: float) -> void:
	if !playing:
		return
		
	song_time = audio_player.get_playback_position()
	score_text.text = "Score: " + str(Global.score)
	
	while next_tile < chart.size():
		var tile: Dictionary = chart[next_tile]
		
		if tile["time"] > song_time:
			break
			
		spawn_tiles(tile)
		next_tile += 1
			
func spawn_tiles(note: Dictionary) -> void:
	var tile = tile_scene.instantiate()
	tiles_scene.add_child(tile)
	
	tile.position = Vector2(note["lane"] * 180, -448)

func _on_pause_button_pressed() -> void:
	audio_player.stream_paused = true
	pause_screen.visible = true
	Global.paused = true

func _on_resume_button_pressed() -> void:
	audio_player.stream_paused = false
	pause_screen.visible = false
	Global.paused = false

func _on_reset_button_pressed() -> void:
	Global.score = 0
	queue_free()
	get_tree().change_scene_to_file("res://scenes/play_area.tscn")
	Global.paused = false

func _on_quit_button_pressed() -> void:
	var wait_time = 0.25
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(background_layer, "offset", Vector2(-720, 0), wait_time)
	tween.tween_property(tiles_scene, "offset", Vector2(-720, 0), wait_time)
	tween.tween_property(pause_screen, "offset", Vector2(-720, 0), wait_time)
	tween.tween_property(ui_layer, "offset", Vector2(-720, 0), wait_time)
	await get_tree().create_timer(wait_time).timeout
	Global.paused = false
	queue_free()
