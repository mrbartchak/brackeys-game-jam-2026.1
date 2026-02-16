class_name MainMenu
extends Control

@onready var play_btn: TextureButton = %PlayButton
@onready var about_btn: TextureButton = %AboutButton

func _ready() -> void:
	play_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://levels/level_manager.tscn")
	)
	about_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://ui/about.tscn")
	)
