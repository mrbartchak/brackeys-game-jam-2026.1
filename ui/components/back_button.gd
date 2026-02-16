class_name BackButton
extends TextureButton

@export var back_scene_name: String

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	TransitionManager.transition_to(back_scene_name, 0.6, TransitionManager.TransitionDirection.RIGHT)
