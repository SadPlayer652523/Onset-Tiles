extends CanvasLayer

@onready var label: RichTextLabel = $RichTextLabel

func _process(delta: float) -> void:
	label.text = Global.global_error
