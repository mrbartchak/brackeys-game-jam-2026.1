class_name Eyeicon
extends AnimatedSprite2D

var _open: bool = false

func open() -> void:
	_open = true
	play("open")

func close() -> void:
	_open = false
	play("close")

func is_open() -> bool:
	return _open
