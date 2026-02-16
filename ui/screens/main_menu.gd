class_name MainMenu
extends Control

@onready var play_btn: TextureButton = %PlayButton
@onready var about_btn: TextureButton = %AboutButton
@onready var quit_btn: TextureButton = %QuitButton

func _ready() -> void:
	play_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://ui/screens/level_select.tscn"))
	about_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://ui/screens/about.tscn"))
	quit_btn.pressed.connect(func():
		get_tree().quit())
