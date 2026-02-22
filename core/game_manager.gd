extends Node

const level_list: Dictionary = {
	"level_01": preload("res://levels/level_data/level_01.tres"),
	"level_02": preload("res://levels/level_data/level_02.tres"),
	"level_03": preload("res://levels/level_data/level_03.tres"),
	"level_04": preload("res://levels/level_data/level_04.tres"),
	"level_05": preload("res://levels/level_data/level_05.tres"),
	"level_06": preload("res://levels/level_data/level_06.tres"),
	"level_07": preload("res://levels/level_data/level_07.tres"),
	"level_08": preload("res://levels/level_data/level_08.tres"),
	"level_09": preload("res://levels/level_data/level_09.tres"),
	"level_10": preload("res://levels/level_data/level_10.tres"),
	"level_11": preload("res://levels/level_data/level_11.tres"),
	"level_12": preload("res://levels/level_data/level_12.tres"),
	"level_13": preload("res://levels/level_data/level_13.tres")
}

var current_level_data: LevelData
var completed_levels: Array[String] = []
var unlocked_levels: Array[String] = []

var input_locked: bool = false 

func _ready() -> void:
	if unlocked_levels.is_empty():
		#unlocked_levels.append_array(level_list.keys())
		unlocked_levels.append("level_01")

func load_level(level_id: String) -> void:
	if not level_list.has(level_id):
		print("err: level does not exist")
		return
	if not unlocked_levels.has(level_id):
		print("warn: level is locked")
		return
	current_level_data = level_list.get(level_id)
	get_tree().change_scene_to_file("res://levels/level.tscn")

#func complete_level(level_id: String) -> void:
	#

func get_next_level_id(current_level: String) -> String:
	var keys = level_list.keys()
	var current_index = keys.find(current_level)
	var next_index = current_index + 1
	if next_index < keys.size():
		return keys[next_index]
	return "level_none"

func lock_input() -> void:
	input_locked = true
func unlock_input() -> void:
	input_locked = false

func level_won(level: String) -> void:
	var next_level_id = get_next_level_id(level)
	if not unlocked_levels.has(next_level_id):
		unlocked_levels.append(next_level_id)
