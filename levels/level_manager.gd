class_name LevelManager
extends Node2D

@export var level_data: LevelData

var current_score: int = 0
var target_zone_scene: PackedScene = preload("res://target_zones/target_zone.tscn")
var target_zone_2_scene: PackedScene = preload("res://target_zones/target_zone_2.tscn")
var target_zone_3_scene: PackedScene = preload("res://target_zones/target_zone_3.tscn")
var block_scene: PackedScene = preload("res://blocks/block.tscn")
var eye_icon_scene: PackedScene = preload("res://ui/components/eye_icon.tscn")
var eye_icon_dripping_scene: PackedScene = preload("res://ui/components/eye_icon_dripping.tscn")
var block_types: Dictionary = {
	"block_1x1": preload("res://blocks/types/block_1x1.tres"),
	"block_1x2": preload("res://blocks/types/block_1x2.tres"),
	"block_1x3": preload("res://blocks/types/block_1x3.tres"),
	"block_2x2": preload("res://blocks/types/block_2x2.tres")
}

@onready var target_zone_container: Node2D = $TargetZones
@onready var block_container: Node2D = $Blocks
# UI
@onready var level_label: RichTextLabel = %LevelLabel
@onready var win_screen: Control = %WinScreen
@onready var score_label: Label = %ScoreLabel
@onready var eye_board: Control = %EyeBoard

func _ready() -> void:
	level_data = GameManager.current_level_data
	if level_data:
		_build_level()
	GameManager.unlock_input()
	_update_ui()
	init_eye_icons()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		get_tree().reload_current_scene()

# =======================
# ==== Level Build ======
# =======================
func _build_level() -> void:
	_spawn_target_zones()
	_spawn_blocks()

func _spawn_target_zones() -> void:
	for spawn_position in level_data.target_zone_positions:
		var target_zone: TargetZone = target_zone_scene.instantiate()
		target_zone.position = spawn_position
		target_zone_container.add_child(target_zone)

func _spawn_blocks() -> void:
	for block_config in level_data.blocks:
		if not block_types.has(block_config.block_id):
			push_warning("block type does not exist")
		var block: Block = block_scene.instantiate()
		block.block_type = block_types.get(block_config.block_id)
		block.position = block_config.position
		block.is_absorber = block_config.is_absorber
		block.placed.connect(_try_score)
		block_container.add_child(block)

# =======================
# ======= Scoring =======
# =======================
func _try_score(block: Block) -> void:
	var is_valid: bool = false
	var scored_zones: Array[TargetZone] = []
	for target_zone: TargetZone in target_zone_container.get_children():
		if target_zone.is_covered:
			is_valid = true
			scored_zones.append(target_zone)
	if is_valid and not block.is_absorber:
		_begin_score_sequence(block, scored_zones)
		return
	elif is_valid and block.is_absorber:
		_absorb_zones(block, scored_zones)
	#not valid then... so return block somehow?

func _absorb_zones(block: Block, scored_zones: Array[TargetZone]) -> void:
	var absorbed_value: int = _tally_points(block, scored_zones)
	var block_pos: Vector2 = block.global_position
	_begin_score_sequence(block, scored_zones)
	await get_tree().create_timer(0.35).timeout
	_spawn_merged_zone(block_pos, absorbed_value)

func _spawn_merged_zone(spawn_pos: Vector2, absorbed_value: int) -> void:
	var zone: TargetZone
	if absorbed_value == 1:
		zone = target_zone_scene.instantiate()
		zone.value = 1
	elif absorbed_value == 2:
		zone = target_zone_2_scene.instantiate()
		zone.value = 2
	else:
		zone = target_zone_3_scene.instantiate()
		zone.value = 3
	zone.position = spawn_pos
	zone.is_covered = false
	target_zone_container.add_child(zone)

func _begin_score_sequence(block: Block, scored_zones: Array[TargetZone]) -> void:
	GameManager.lock_input()
	var total_points: int = _tally_points(block, scored_zones)

	_play_block_scored_effect(block)
	for scored_zone: TargetZone in scored_zones:
		_play_target_zone_pop(scored_zone)
	#await get_tree().create_timer(0.5).timeout
	#await for them to be done
	#tally the points
	#add to score
	_score(total_points)
	#remove nodes
	GameManager.unlock_input()

func _tally_points(_block: Block, scored_zones: Array[TargetZone]) -> int:
	var points: int = 0
	for scored_zone: TargetZone in scored_zones:
		points += scored_zone.value
	return points


func _score(points: int) -> void:
	current_score += points
	_update_ui()
	_check_win()

func _check_win() -> void:
	if current_score >= level_data.target_score:
		_win()

func _win() -> void:
	GameManager.lock_input()
	await get_tree().create_timer(.5).timeout
	AudioManager.play_win()
	GameManager.level_won(level_data.id)
	win_screen.show()

# =======================
# ========= UI ==========
# =======================
func _update_ui() -> void:
	level_label.text = "[wave]" + level_data.display_name
	score_label.text = str(current_score)
	_update_eyes()

func init_eye_icons() -> void:
	var total_eyes: int = level_data.target_score
	for i in range(total_eyes):
		var eye_icon: Eyeicon = eye_icon_scene.instantiate()
		var offset: float = (i - (total_eyes - 1) / 2.0) * 24
		eye_icon.position.x = offset
		eye_board.add_child(eye_icon)
		print("eye added")

func _update_eyes() -> void:
	for i in range(current_score):
		if i>= level_data.target_score:
			_spawn_bonus_eye(i)
			var eye_icon: Eyeicon = eye_board.get_child(i % level_data.target_score)
			eye_icon.hide()
			continue
		var eye_icon: Eyeicon = eye_board.get_child(i)
		if not eye_icon.is_open():
			eye_icon.open()

func _spawn_bonus_eye(index: int) -> void:
	var i: int = index % level_data.target_score
	var offset: float = (i - (level_data.target_score - 1) / 2.0) * 24
	var eye_icon_dripping: Eyeicon = eye_icon_dripping_scene.instantiate()
	eye_icon_dripping.position.x = offset
	eye_board.add_child(eye_icon_dripping)
	eye_icon_dripping.open()
# =======================
# ======= Helpers =======
# =======================
func _play_target_zone_pop(area: Node2D) -> void:
	AudioManager.play_zone_scored()
	var tween = create_tween()
	tween.tween_property(area, "scale", Vector2.ZERO, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	area.queue_free()

func _play_block_scored_effect(block: Node2D) -> void:
	await get_tree().create_timer(0.1).timeout
	var tween = create_tween()
	tween.tween_property(block, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(block, "scale", Vector2.ZERO, 0.2)
	await tween.finished
	block.queue_free()
