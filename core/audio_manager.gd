extends AudioStreamPlayer

var sfx_player: AudioStreamPlayer

var sfx_block_rotate: AudioStream = preload("res://core/audio/pen_click.wav")
var sfx_deep_pop: AudioStream = preload("res://core/audio/deep_pop.wav")
var sfx_win: AudioStream = preload("res://core/audio/win_sound.wav")

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func play_sfx(audio: AudioStream, pitch_range: float = 0.0, volume: float = 0.0) -> void:
	sfx_player.pitch_scale = 1.0 if pitch_scale == 0.0 else randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	sfx_player.stream = audio
	sfx_player.volume_db = volume
	sfx_player.play()

func play_block_rotate(pitch_range: float = 0.0, volume: float = -10.0) -> void:
	play_sfx(sfx_block_rotate, pitch_range, volume)

func play_zone_scored(pitch_range: float = 0.0, volume: float = 0.0) -> void:
	play_sfx(sfx_deep_pop, pitch_range, volume)

func play_win(pitch_range: float = 0.0, volume: float = 0.0) -> void:
	play_sfx(sfx_win, pitch_range, volume)
