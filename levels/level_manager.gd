class_name LevelManager
extends Node2D

@export var level_data: LevelData

var target_zone_scene: PackedScene = preload("res://target_zones/target_zone.tscn")
var block_scene: PackedScene = preload("res://blocks/block.tscn")
var block_types: Dictionary = {
	"block_1x1": preload("res://blocks/types/block_1x1.tres"),
	"block_1x2": preload("res://blocks/types/block_1x2.tres")
}

@onready var target_zone_container: Node2D = $TargetZones
@onready var block_container: Node2D = $Blocks
@onready var level_label: Label = %LevelLabel
@onready var win_screen: Control = %WinScreen

func _ready() -> void:
	level_data = GameManager.current_level_data
	if level_data:
		_build_level()
	GameManager.unlock_input()
	level_label.text = level_data.display_name

func _build_level() -> void:
	_spawn_target_zones()
	_spawn_blocks()

func _spawn_target_zones() -> void:
	for spawn_position in level_data.target_zone_positions:
		var target_zone: TargetZone = target_zone_scene.instantiate()
		target_zone.position = spawn_position
		target_zone_container.add_child(target_zone)

func _spawn_blocks() -> void:
	for block_id in level_data.block_ids:
		if not block_types.has(block_id):
			print("err: block type does not exist")
		var block: Block = block_scene.instantiate()
		block.block_type = block_types.get(block_id)
		block.placed.connect(_check_win)
		block_container.add_child(block)

func _check_win() -> void:
	for target_zone: TargetZone in target_zone_container.get_children():
		if not target_zone.is_covered:
			return
	_win()

func _win() -> void:
	GameManager.lock_input()
	await get_tree().create_timer(.3).timeout
	win_screen.show()
	print("win")
