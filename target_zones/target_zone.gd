class_name TargetZone
extends Area2D

var overlapping_areas: int = 0

@onready var sprite: Sprite2D = $Sprite
@onready var sprite_filled: Sprite2D = $SpriteFilled


func _on_area_entered(area: Area2D) -> void:
	overlapping_areas += 1
	sprite.hide()
	sprite_filled.show()

func _on_area_exited(area: Area2D) -> void:
	overlapping_areas -= 1
	if overlapping_areas == 0:
		sprite.show()
		sprite_filled.hide()
