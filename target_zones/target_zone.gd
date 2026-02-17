class_name TargetZone
extends Area2D

var value: int = 1

var overlapping_blocks: int = 0
var is_covered: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var sprite_filled: Sprite2D = $SpriteFilled

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
		sprite.hide()
		sprite_filled.show()
	else:
		sprite.show()
		sprite_filled.hide()
