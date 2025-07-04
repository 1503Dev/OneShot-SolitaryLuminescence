extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_text: AnimationPlayer = $Label/AnimationPlayer
@onready var label: Label = $Label

var current_data := []
var current_index := 0
var can_interact := false

func open(_data:Array):
	label.text = ""
	current_data = _data
	current_index = 0
	G.can_exit = false
	G.can_interact = false
	G.can_open_gui = false
	animation_player.play("fade_in")
	show()
	_show_next_text()

func close():
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	hide()
	G.can_exit = true
	G.can_interact = true
	G.can_open_gui = true
	current_data = []

func _show_next_text():
	animation_player_text.play_backwards("fade_in")
	await animation_player_text.animation_finished
	label.text = ""
	if current_index >= current_data.size():
		close()
		return
	
	label.text = tr("dialog.wm." + str(current_data[current_index]))
	animation_player_text.play("fade_in")
	await animation_player_text.animation_finished
	await G.sleep(1)
	can_interact = true

func _input(event):
	if not can_interact: return
	if event.is_action_pressed("interact"):
		can_interact = false
		current_index += 1
		_show_next_text()

func _ready() -> void:
	hide()
