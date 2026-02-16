extends CanvasLayer

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	layer = 100

func _process(_delta: float) -> void:
	sprite.global_position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_tween_scale(1.2)
	if event.is_action_released("click"):
		_tween_scale(1.0)

func _tween_scale(target_scale: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(target_scale, target_scale), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
