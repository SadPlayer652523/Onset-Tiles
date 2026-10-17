extends CanvasLayer

@onready var screen_canvas: CanvasLayer = $CanvasLayer

const screens = [0, -720]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_new_button_pressed() -> void:
	screen_canvas.offset.x = screens[1]

func _on_back_button_pressed() -> void:
	screen_canvas.offset.x = screens[0]
