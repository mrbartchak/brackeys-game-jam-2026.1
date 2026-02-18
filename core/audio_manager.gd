extends AudioStreamPlayer

var sfx_player: AudioStreamPlayer

var sfx_pen_click: AudioStream = preload("res://core/audio/pen_click.wav")
var sfx_deep_pop: AudioStream = preload("res://core/audio/deep_pop.wav")
var sfx_win: AudioStream = preload("res://core/audio/win_sound.wav")

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	get_tree().node_added.connect(_on_node_added)
	_connect_existing_buttons(get_tree().root)

func play_sfx(audio: AudioStream, pitch_range: float = 0.0, volume: float = 0.0) -> void:
	sfx_player.pitch_scale = 1.0 if pitch_scale == 0.0 else randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	sfx_player.stream = audio
	sfx_player.volume_db = volume
	sfx_player.play()

func play_button_click() -> void:
	play_sfx(sfx_pen_click, 0.2, -15.0)

func play_block_rotate(pitch_range: float = 0.0, volume: float = -15.0) -> void:
	play_sfx(sfx_pen_click, pitch_range, volume)

func play_zone_scored(pitch_range: float = 0.0, volume: float = 0.0) -> void:
	play_sfx(sfx_deep_pop, pitch_range, volume)

func play_win(pitch_range: float = 0.0, volume: float = 0.0) -> void:
	play_sfx(sfx_win, pitch_range, volume)



func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(play_button_click)

func _connect_existing_buttons(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(play_button_click)
	for child in node.get_children():
		_connect_existing_buttons(child)
