extends Button

signal play

@onready var cover: TextureRect = $Cover
@onready var title_label: RichTextLabel = $"Title Label"
@onready var artist_label: RichTextLabel = $"Artist Label"
@onready var bpm_label: RichTextLabel = $"BPM Label"
@onready var score_label: RichTextLabel = $"Score Label"
@onready var difficulty_label: RichTextLabel = $"Difficulty Label"

var chart_path: String

var title: String
var bpm
var difficulty: String
var artist: String
var cover_texture
var high_score: int

func _ready() -> void:
	if bpm != -1:
		if bpm < 120:
			difficulty = "Easy"
		elif bpm <= 140:
			difficulty = "Normal"
		else:
			difficulty = "Hard"
	else:
		difficulty = "Unknown"
	bpm_label.text = str(int(bpm)) if bpm != -1 else "Unknown"
	title_label.text = title
	artist_label.text = "Artist: " + artist
	difficulty_label.text = difficulty
	score_label.text = str(high_score)
	if cover_texture:
		cover.texture = cover_texture

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Global.current_song_directory = chart_path
	play.emit()
