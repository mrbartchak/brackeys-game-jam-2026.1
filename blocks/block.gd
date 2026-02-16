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
	if not is_dragging:
		_tween_scale(1.1)

func _mouse_exit() -> void:
	is_hovered = false
	if not is_dragging:
		_tween_scale(1.0)

func _tween_scale(target_scale: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(target_scale, target_scale), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
