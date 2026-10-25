extends Node2D

signal fail

@onready var button: Button = $Button
@onready var collision: Area2D = $Button/Area2D

const speed = 750.333

var allow_score = false
var missed = false
var tweening = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_instance_valid(button) and !Global.paused:
		if !Global.failed:
			position.y += speed * (Global.song_settings["bpm"] / 100.0) * delta
		else:
			if !tweening:
				tweening = true
				fail_song()
		if position.y > Global.hit_line_position_y and !missed:
			missed = true
			button.disabled = true
			Global.tiles_missed += 1
		if position.y > 2500.0:
			queue_free()
			
func fail_song() -> void:
	var current_speed = speed * (Global.song_settings["bpm"] / 100.0)
	var duration = (60.0 / Global.song_settings["bpm"]) * 0.75
	Global.duration = duration
	var target_y = position.y + (current_speed * duration * 0.5)
	fail.emit()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", target_y, duration)

func _on_button_pressed() -> void:
	if allow_score:
		Global.score += 1
	else:
		Global.tiles_missed += 1
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hit Line Area2D":
		allow_score = true
