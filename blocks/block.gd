class_name Block
extends Area2D

signal placed
signal filled_changed(is_filled: bool)
@export var block_type: BlockType

static var dragged_block: Block = null
var is_filled: bool
var is_locked: bool

var _is_dragging: bool = false
var _is_hovered: bool = false
var _rotation_step: int = 0

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
	_update_visuals()

func _physics_process(delta: float) -> void:
	if _is_dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 32.0 * delta)

func _input(event: InputEvent) -> void:
	if GameManager.input_locked:
		return
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if _is_hovered and not _is_dragging and dragged_block == null:
				_grab_block()
			elif _is_dragging:
				_place_block()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and _is_dragging:
			_rotate_block()

# ========================
# ======  ACTIONS   ======
# ========================
func _grab_block() -> void:
	_is_dragging = true
	dragged_block = self
	_tween_scale(1.1)

func _place_block() -> void:
	_is_dragging = false
	dragged_block = null
	_tween_scale(1.0)
	placed.emit()

func _rotate_block() -> void:
	print("rotate triggered")
	_rotation_step += 1
	var target_angle: float = _rotation_step * PI / 4.0
	global_position = get_global_mouse_position()
	_tween_rotate(target_angle)






#func _check_fill() -> void:
	#for area in get_overlapping_areas():
		#if area.is_in_group("blocks") and area.is_filled:
			#is_filled = true
			#return
	#is_filled = false
#
func _fill_block() -> void:
	if is_locked:
		return
	filled_changed.emit(true)

func _unfill_block() -> void:
	if is_locked:
		return
	filled_changed.emit(false)

func _update_visuals() -> void:
	if is_filled:
		sprite.texture = block_type.texture_filled
	else:
		sprite.texture = block_type.texture_unfilled

# ========================
# ======  SIGNALS   ======
# ========================
func _mouse_enter() -> void:
	_is_hovered = true
	if dragged_block:
		return
	if not _is_dragging:
		_tween_scale(1.35)

func _mouse_exit() -> void:
	_is_hovered = false
	if not _is_dragging:
		_tween_scale(1.0)

#func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("blocks"):
		#area = area as Block
		#area.filled_changed.connect()
		#if area.is_filled:
			#_fill_block()
#
#func _on_area_exited(area: Area2D) -> void:
	#pass # Replace with function body.

# ========================
# ======  HELPERS   ======
# ========================
var _scale_tween: Tween = null
var _rotate_tween: Tween = null

func _tween_scale(target_scale: float) -> void:
	if _scale_tween: _scale_tween.kill()
	_scale_tween = create_tween()
	_scale_tween.tween_property($Sprite, "scale", Vector2(target_scale, target_scale), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _tween_rotate(target_rotation: float) -> void:
	if _rotate_tween: _rotate_tween.kill()
	_rotate_tween = create_tween()
	_rotate_tween.tween_property(self, "rotation", target_rotation, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
