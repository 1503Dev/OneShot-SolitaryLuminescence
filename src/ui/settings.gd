extends CanvasLayer

@onready var control: Control = $Control
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var sound_effect: SoundEffect = $Control/SoundEffect3

var title:Node
var is_ready:= false
var last_niko_can_interact:= false

func _ready() -> void:
	hide()

func open() -> void:
	if G.niko:
		last_niko_can_interact = G.can_interact
		G.can_interact = false
	show()
	if G.in_game: sound_effect.play('menu_decision')
	animation_player.play('fade_in')
	#get_tree().paused = true
	await animation_player.animation_finished
	if visible:
		is_ready = true
		TouchUi.switch('settings')
	
func close() -> void:
	is_ready = false
	sound_effect.play('menu_cancel')
	#get_tree().paused = false
	animation_player.play_backwards('fade_in')
	TouchUi.hide_all()
	await animation_player.animation_finished
	if title: title.action_disabled = false
	hide()
	G.can_interact = last_niko_can_interact


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_cancel'):
		if !visible or !is_ready: return
		is_ready = false
		close()
	if G.can_open_gui and Input.is_action_just_pressed('settings'):
		if is_ready:
			close()
		elif !visible:
			open()
