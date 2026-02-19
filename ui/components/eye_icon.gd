class_name Eyeicon
extends AnimatedSprite2D

@export var start_awake: bool = false
var _open: bool = false

func _ready() -> void:
	if start_awake:
		#play("staring")
		await get_tree().create_timer(0.5).timeout
		open()

func open() -> void:
	_open = true
	play("open")
	_blink_loop()

func close() -> void:
	_open = false
	play("close")

func is_open() -> bool:
	return _open

func _blink_loop() -> void:
	var wait_time: float = randf_range(3.0, 8.0)
	await get_tree().create_timer(wait_time).timeout
	_blink()
	await self.animation_finished
	_idle()
	_blink_loop()

func _blink() -> void:
	#AudioManager.play_blink()
	self.play("blink")

func _idle() -> void:
	self.play("staring")
