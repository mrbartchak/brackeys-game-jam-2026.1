class_name WinScreen
extends Control

func _ready() -> void:
	%NextButton.pressed.connect(_on_next_pressed)

func _on_next_pressed() -> void:
	GameManager.load_level(GameManager.get_next_level_id(GameManager.current_level_data.id))
