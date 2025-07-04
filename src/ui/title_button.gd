extends Control
class_name TitleButton

@export var text:= ''
@export var sound_effect_player:AudioStreamPlayer
@export var action_handler:Node
@export var action:= ''

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.hide()
	label.text = text

func _on_texture_button_mouse_entered() -> void:
	if action_handler and action_handler.action_disabled: return
	if sound_effect_player:
		sound_effect_player.stop()
		sound_effect_player.volume_db = -12
		sound_effect_player.stream = load("res://src/audios/sound_effect/title_cursor.wav")
		sound_effect_player.play()
	texture_rect.show()

func _on_texture_button_mouse_exited() -> void:
	texture_rect.hide()

func _on_texture_button_pressed() -> void:
	if action_handler and action_handler.action_disabled: return
	if sound_effect_player:
		sound_effect_player.stop()
		sound_effect_player.volume_db = 0
		if text == 'settings': sound_effect_player.stream = load("res://src/audios/sound_effect/menu_decision.wav")
		else: sound_effect_player.stream = load("res://src/audios/sound_effect/title_decision.wav")
		sound_effect_player.play()
	if action_handler:
		action_handler.act(action)
