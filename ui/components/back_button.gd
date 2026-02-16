class_name BackButton
extends TextureButton

@export var back_scene: PackedScene

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(back_scene)
