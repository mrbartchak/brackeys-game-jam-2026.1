class_name PauseMenu
extends Control

func _ready() -> void:
	hide()
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func _on_back_button_pressed() -> void:
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	_toggle_pause()
