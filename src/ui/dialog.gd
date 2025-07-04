extends CanvasLayer
class_name Dialog

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Control/Dialog/Label
@onready var face: TextureRect = $Control/Dialog/Face
@onready var cursor: Sprite2D = $Control/Dialog/Cursor
@onready var options: Control = $Control/Options
@onready var dialog_option_1: Control = $Control/Options/DialogOption1
@onready var dialog_option_2: Control = $Control/Options/DialogOption2
@onready var audio_stream_player_text: AudioStreamPlayer = $AudioStreamPlayer_Text
@onready var audio_stream_player_text_robot: AudioStreamPlayer = $AudioStreamPlayer_TextRobot

var data := []
var current_obj = null
var current_index := 0
var text_speed := 100
var timer := 0.0
var is_typing := false
var can_interact := false
var current_text_array := []
var current_array_index := 0
var dialog_map := {}
var dialog_id
var sound_interval := 5
var char_count := 0
var is_robot := false
var last_who = null

func _ready():
	options.hide()
	cursor.hide()

func close():
	data = []
	current_index = 0
	current_obj = null
	current_text_array = []
	current_array_index = 0
	dialog_map = {}
	if dialog_id: G.is_read(dialog_id)
	dialog_id = null
	animation_player.play_backwards('fade_in')
	await animation_player.animation_finished
	hide()
	G.can_interact = true
	G.can_open_gui = true
	G.can_exit = true

func open(_data:Array, id = null):
	dialog_id = id
	dialog_map = {}
	for obj in _data:
		if obj.has("id"):
			dialog_map[str(obj.id)] = obj
	G.can_interact = false
	G.can_open_gui = false
	G.can_exit = false
	data = _data
	current_index = 0
	animation_player.play('fade_in')
	show()
	if data.size() > 0:
		_start_dialog(data[0])

func _start_dialog(obj):
	current_obj = obj
	label.text = ""
	current_text_array = []
	current_array_index = 0
	char_count = 0
	
	if current_obj.has("who"):
		last_who = current_obj.who
		face.texture = load("res://src/graphics/faces/" + str(current_obj.who) + ".png")
		is_robot = str(current_obj.who).begins_with("blue_gatekeeper") || str(current_obj.who).begins_with("bookbot") || str(current_obj.who).begins_with("prophet") || str(current_obj.who).begins_with("proto") || str(current_obj.who).begins_with("red_gatekeeper") || str(current_obj.who).begins_with("rowbot") || str(current_obj.who).begins_with("silver")
	else:
		if last_who:
			face.texture = load("res://src/graphics/faces/" + str(last_who) + ".png")
			is_robot = str(last_who).begins_with("blue_gatekeeper") || str(last_who).begins_with("bookbot") || str(last_who).begins_with("prophet") || str(last_who).begins_with("proto") || str(last_who).begins_with("red_gatekeeper") || str(last_who).begins_with("rowbot") || str(last_who).begins_with("silver")
	
	_play_sound()
	
	if current_obj.text is Array:
		current_text_array = current_obj.text
		_show_next_array_text()
	else:
		_show_text(_process_text(str(current_obj.text)))

func _process_text(text:String):
	var processed = tr('dialog.' + text)
	if processed.contains('%s'): processed = processed % G.get_player_name()
	if is_robot:
		return "[" + processed + "]"
	return processed

func _show_next_array_text():
	if current_array_index >= current_text_array.size():
		_check_show_options()
		return
	var text = _process_text(str(current_text_array[current_array_index]))
	if current_array_index == 0:
		_show_text(text)
	else:
		_append_text(text)
	current_array_index += 1

func _show_text(text:String):
	label.text = text
	label.visible_characters = 0
	is_typing = true
	can_interact = false
	cursor.hide()

func _append_text(text:String):
	label.text += text
	label.visible_characters = label.text.length() - text.length()
	is_typing = true
	can_interact = false
	cursor.hide()

func _play_sound():
	if is_robot:
		audio_stream_player_text_robot.play()
	else:
		audio_stream_player_text.play()

func _check_show_options():
	is_typing = false
	can_interact = true
	if current_obj.has("options") and current_obj.options.size() > 0 and current_array_index >= current_text_array.size():
		var option_texts = []
		var callbacks = []
		for option in current_obj.options:
			option_texts.append(str(option.text))
			callbacks.append(_on_option_selected.bind(option.goto))
		show_options(option_texts, callbacks)
	else:
		cursor.visible = true

func _on_option_selected(goto_id):
	if dialog_map.has(str(goto_id)):
		_start_dialog(dialog_map[str(goto_id)])

func _physics_process(delta: float) -> void:
	if !is_typing: return
	timer += delta * text_speed
	if timer >= 1.0:
		timer = 0.0
		if label.visible_characters < label.text.length():
			label.visible_characters += 1
			char_count += 1
			if char_count % sound_interval == 0:
				_play_sound()
		else:
			_check_show_options()

func _input(event):
	if not can_interact: return
	if event.is_action_pressed("interact") and visible:
		if is_typing:
			label.visible_characters = label.text.length()
			_check_show_options()
		else:
			if current_array_index < current_text_array.size():
				_show_next_array_text()
			else:
				if !current_obj: return
				if current_obj.has("options") and current_obj.options.size() > 0:
					return
				if current_obj.has("goto"):
					if dialog_map.has(str(current_obj.goto)):
						_start_dialog(dialog_map[str(current_obj.goto)])
				else:
					close()

func show_options(texts:Array, callbacks:Array):
	options.hide()
	dialog_option_1.hide()
	dialog_option_2.hide()
	var length:= texts.size()
	if length >= 1:
		dialog_option_1.set_text(texts[0])
		dialog_option_1.set_on_click(callbacks[0])
		dialog_option_1.show()
		options.show()
	if length >= 2:
		dialog_option_2.set_text(texts[1])
		dialog_option_2.set_on_click(callbacks[1])
		dialog_option_2.show()
