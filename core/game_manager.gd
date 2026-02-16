extends Node

const level_list: Dictionary = {
	"level_01": preload("res://levels/level_data/level_01.tres")
}

var current_level_data: LevelData
var completed_levels: Array[String] = []
var unlocked_levels: Array[String] = []

func _ready() -> void:
	if unlocked_levels.is_empty():
		unlocked_levels.append("level_01")

func load_level(level_id: String) -> void:
	if not level_list.has(level_id):
		print("err: level does not exist")
		return
	if not unlocked_levels.has(level_id):
		print("warn: level is locked")
		return
	current_level_data = level_list.get(level_id)
	get_tree().change_scene_to_file("res://levels/level_manager.tscn")
