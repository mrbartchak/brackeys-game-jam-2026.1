class_name MainMenu
extends Control

@onready var play_btn: TextureButton = %PlayButton
@onready var controls_btn: TextureButton = %ControlsButton
@onready var about_btn: TextureButton = %AboutButton
@onready var quit_btn: TextureButton = %QuitButton

func _ready() -> void:
	play_btn.pressed.connect(func():
		TransitionManager.transition_to("level_select"))
	controls_btn.pressed.connect(func():
		TransitionManager.transition_to("controls"))
	about_btn.pressed.connect(func():
		TransitionManager.transition_to("about"))
	quit_btn.pressed.connect(func():
		get_tree().quit())
