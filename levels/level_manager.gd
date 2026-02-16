class_name LevelManager
extends Node2D

@export var level_data: LevelData

var target_zone_scene: PackedScene = preload("res://target_zones/target_zone.tscn")
var block_scene: PackedScene = preload("res://blocks/block.tscn")
var block_types: Dictionary = {
	"block_1x1": preload("res://blocks/types/block_1x1.tres")
}

@onready var target_zone_container: Node2D = $TargetZones
@onready var block_container: Node2D = $Blocks

func _ready() -> void:
	if level_data:
		_build_level()

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
		var block: Block = block_scene.instantiate()
		block.block_type = block_types.get(block_id)
		block_container.add_child(block)
		
