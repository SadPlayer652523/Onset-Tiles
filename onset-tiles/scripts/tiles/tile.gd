extends Node2D

@onready var button: Button = $Button

var speed = 750.333

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.y += speed * (Global.song_settings["bpm"] / 100.0) * delta

func _on_button_pressed() -> void:
	button.hide()
