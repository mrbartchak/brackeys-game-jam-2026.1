class_name TargetZone
extends Area2D

var value: int = 1

var overlapping_blocks: int = 0
var is_covered: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var sprite_filled: AnimatedSprite2D = $AnimatedSprite/AnimatedSpriteFilled
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.seek(randf() * animation_player.current_animation_length)
	animation_player.speed_scale = randf_range(0.70, 0.8)
	_blink_loop()

func score() -> int:
	self.monitoring = false
	sprite.hide()
	sprite_filled.hide()
	return value

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("blocks"):
		area = area as Block
		area.filled_changed.connect(_check_covered)
		_check_covered()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("blocks"):
		area = area as Block
		area.filled_changed.disconnect(_check_covered)
		_check_covered()

func _check_covered() -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("blocks") and area.is_filled:
			is_covered = true
			_update_visuals()
			return
	is_covered = false
	_update_visuals()

func _update_visuals() -> void:
	if is_covered:
		#sprite.hide()
		sprite_filled.show()
	else:
		#sprite.show()
		sprite_filled.hide()

func _blink_loop() -> void:
	var wait_time: float = randf_range(3.0, 8.0)
	await get_tree().create_timer(wait_time).timeout
	_blink()
	await sprite.animation_finished
	_idle()
	_blink_loop()

func _blink() -> void:
	AudioManager.play_blink()
	sprite.play("blink")
	sprite_filled.play("blink")

func _idle() -> void:
	sprite.play("default")
	sprite_filled.play("default")
