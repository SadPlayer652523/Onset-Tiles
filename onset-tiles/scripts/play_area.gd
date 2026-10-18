extends CanvasLayer

@export var tile_scene: PackedScene

var current_song_directory = "res://songs/Test"

var chart = []
var next_tile = 0
var song_time = 0.0
var playing = false

func start_chart(directory: String) -> void:
	chart = Global.load_lrc(directory)
	chart.sort_custom(func(a, b): return a["time"] < b["time"])
	
	next_tile = 0
	song_time = 0
	playing = true

func _ready() -> void:
	Global.song_settings = Global.load_song_settings(current_song_directory)
	start_chart("res://songs/Test")

func _process(delta: float) -> void:
	if !playing:
		return
		
	song_time += delta
	
	while next_tile < chart.size():
		var tile: Dictionary = chart[next_tile]
		
		if tile["time"] > song_time:
			break
			
		spawn_tiles(tile)
		next_tile += 1
			
func spawn_tiles(note: Dictionary) -> void:
	var tile = tile_scene.instantiate()
	add_child(tile)
	
	tile.position = Vector2(note["lane"] * 180, -100)

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
