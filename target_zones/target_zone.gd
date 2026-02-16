class_name TargetZone
extends Area2D

var overlapping_blocks: int = 0
var is_covered: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var sprite_filled: Sprite2D = $SpriteFilled


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("blocks"):
		overlapping_blocks += 1
		is_covered = true
		_update_visuals()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("blocks"):
		overlapping_blocks -= 1
		is_covered = overlapping_blocks > 0
		_update_visuals()

func _update_visuals() -> void:
	if is_covered:
		sprite.hide()
		sprite_filled.show()
	else:
		sprite.show()
		sprite_filled.hide()
