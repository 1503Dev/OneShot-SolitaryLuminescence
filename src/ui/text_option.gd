extends Control
class_name TextOption

@export var text:= ''
@export var key:= ''
@export var value:= '':
	set(v):
		value = v
		_update_visual()

@export var option_values:= []
@export var option_texts:= []
@export var sound_effect:SoundEffect
@export var sound_effect_2:SoundEffect

@onready var label_text: Label = $Label_Text
@onready var label_value: Label = $Label_Value
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_offset: AnimationPlayer = $AnimationPlayer_Offset

func _update_visual():
	if !label_text: return
	
	label_text.text = text
	
	if value == '': label_value.text = ''
	else:
		var index = option_values.find(value)
		if index == -1: return
		label_value.text = option_texts[index]

func _ready() -> void:
	if key != '' and Option.option.has(key) and Option.option[key] != '': value = Option.option[key]
	_update_visual()

func _on_texture_button_pressed() -> void:
	if key == '': return
	if sound_effect_2: sound_effect_2.play('menu_decision')
	elif sound_effect: sound_effect.play('menu_decision')
	var index = option_values.find(value)
	if index < option_values.size() - 1:
		index += 1
	else: index = 0
	value = option_values[index]
	G.opt(key, value)


func _on_texture_button_mouse_entered() -> void:
	animation_player.play('fade_in')
	animation_player_offset.play('slide_out')
	if sound_effect: sound_effect.play('menu_cursor')


func _on_texture_button_mouse_exited() -> void:
	animation_player.play_backwards('fade_in')
	animation_player_offset.play_backwards('slide_out')
