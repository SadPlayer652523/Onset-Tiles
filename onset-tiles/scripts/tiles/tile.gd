extends Node2D

@onready var button: Button = $Button
@onready var collision: Area2D = $Button/Area2D

const speed = 750.333

var allow_score = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_instance_valid(button) and !Global.paused:
		position.y += speed * (Global.song_settings["bpm"] / 100.0) * delta
		if position.y > Global.hit_line_position_y:
			button.disabled = true
		if position.y > 2500.0:
			queue_free()

func _on_button_pressed() -> void:
	if allow_score:
		Global.score += 1
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hit Line Area2D":
		allow_score = true
