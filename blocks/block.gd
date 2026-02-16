class_name Block
extends Area2D

signal placed
@export var block_type: BlockType

var is_dragging: bool = false
var is_hovered: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var placeholder_shape: CollisionShape2D = $PlaceholderShape

func _ready() -> void:
	placeholder_shape.queue_free()
	for shape in block_type.shapes:
		var collison_shape: CollisionShape2D = CollisionShape2D.new()
		var rect: RectangleShape2D = RectangleShape2D.new()
		rect.size = shape.size
		collison_shape.position = shape.position
		collison_shape.shape = rect
		self.add_child(collison_shape)
	sprite.texture = block_type.texture

func _process(delta: float) -> void:
	if is_dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 32.0 * delta)

func _input(event: InputEvent) -> void:
	if GameManager.input_locked:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_hovered and not is_dragging:
			is_dragging = true
			_tween_scale(1.1)
		elif is_dragging:
			is_dragging = false
			_tween_scale(1.0)
			placed.emit()

func _mouse_enter() -> void:
	is_hovered = true
	if not is_dragging:
		_tween_scale(1.5)

func _mouse_exit() -> void:
	is_hovered = false
	if not is_dragging:
		_tween_scale(1.0)

func _tween_scale(target_scale: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(target_scale, target_scale), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
