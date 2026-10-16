extends Node2D

@onready var button: Button = $Button

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.y += Global.default_speed * delta

func _on_button_pressed() -> void:
	button.hide()
