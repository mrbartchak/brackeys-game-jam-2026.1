class_name LevelButton
extends TextureButton

@export var level_id: String
@export var level_number: String

@onready var level_label: Label = $LevelLabel

func _ready() -> void:
	self.pressed.connect(func():(
		GameManager.load_level(level_id)))
	self.mouse_entered.connect(func():
		level_label.add_theme_color_override("font_color", "#272946"))
	self.mouse_exited.connect(func():
		level_label.add_theme_color_override("font_color", "#e7ffee"))
		
	level_label.text = level_number if level_number else "NaN"
	level_label.add_theme_color_override("font_color", "#e7ffee")
