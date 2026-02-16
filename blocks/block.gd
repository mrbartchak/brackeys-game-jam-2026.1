class_name Block
extends Area2D

var is_dragging: bool = false
var is_hovered: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_hovered and not is_dragging:
			is_dragging = true
		elif is_dragging:
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position()

func _mouse_enter() -> void:
	is_hovered = true

func _mouse_exit() -> void:
	is_hovered = false
