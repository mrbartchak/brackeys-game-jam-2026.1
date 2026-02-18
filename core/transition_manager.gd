extends CanvasLayer

enum TransitionDirection { LEFT, RIGHT }

var scenes: Dictionary = {
	"main_menu": preload("res://ui/screens/main_menu.tscn"),
	"level_select": preload("res://ui/screens/level_select.tscn"),
	"about": preload("res://ui/screens/about.tscn"),
	"controls": preload("res://ui/screens/controls.tscn")
}

func transition_to(scene_name: String, duration: float = 0.6, direction: TransitionDirection = TransitionDirection.LEFT) -> void:
	if not scenes.has(scene_name):
		push_error("TransitionManager: unknown scene error")
		return
	transition_to_packed(scenes.get(scene_name), duration, direction)

func transition_to_packed(scene: PackedScene, duration: float = 0.6, direction: TransitionDirection = TransitionDirection.LEFT) -> void:
	var scene_tree: SceneTree = get_tree()
	var old_scene: Node = scene_tree.current_scene
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var transition_offset: Vector2 = _get_offset(direction, viewport_size)
	
	var new_scene: Node = scene.instantiate()
	scene_tree.root.add_child(new_scene)
	new_scene.set("position", transition_offset)
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(old_scene, "position", -transition_offset, duration) \
		.set_ease(tween.EASE_IN_OUT).set_trans(tween.TRANS_CUBIC)
	tween.tween_property(new_scene, "position", Vector2.ZERO, duration) \
		.set_ease(tween.EASE_IN_OUT).set_trans(tween.TRANS_CUBIC)
	
	tween.chain().tween_callback(func() -> void:
		old_scene.queue_free()
		scene_tree.current_scene = new_scene
	)

func _get_offset(direction: TransitionDirection, size: Vector2) -> Vector2:
	match direction:
		TransitionDirection.LEFT: return Vector2(size.x, 0.0)
		TransitionDirection.RIGHT: return Vector2(-size.x, 0.0)
	return Vector2(size.x, 0.0)
