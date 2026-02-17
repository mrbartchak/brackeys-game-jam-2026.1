extends AudioStreamPlayer

var sfx_player: AudioStreamPlayer

var sfx_block_rotate: AudioStream = preload("res://core/audio/deep_pop.wav")

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func play_sfx(audio: AudioStream, pitch_range: float = 0.0, volume: float = 0.0) -> void:
	sfx_player.pitch_scale = 1.0 if pitch_scale == 0.0 else randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	sfx_player.stream = audio
	sfx_player.volume_db = volume
	sfx_player.play()

func play_block_rotate(pitch_range: float = 0.0, volume: float = 0.0) -> void:
	play_sfx(sfx_block_rotate, pitch_range, volume)
