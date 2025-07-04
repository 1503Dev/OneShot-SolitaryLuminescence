extends Node
class_name SoundEffect

@export var stream: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal finished

var playing:= false

func play(_name:String = '', db:= 0):
	audio_stream_player.stop()
	if _name.is_empty() and stream: audio_stream_player.stream = stream
	else: audio_stream_player.stream = load('res://src/audios/sound_effect/' + _name + '.wav')
	audio_stream_player.volume_db = db
	audio_stream_player.play()

func _process(_delta: float) -> void:
	if audio_stream_player: playing = audio_stream_player.playing

func _ready() -> void:
	audio_stream_player.finished.connect(func():
		finished.emit()
	)
