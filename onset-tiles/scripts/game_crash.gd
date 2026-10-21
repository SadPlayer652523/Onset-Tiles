extends CanvasLayer

@onready var label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	label.text = Global.global_error
