extends CanvasLayer

@onready var UI:= {
	'settings': $Settings,
	'joypad': $Joypad
}

var current:= ''

func _ready() -> void:
	hide_all()

func hide_all():
	current = ''
	for ui in UI.values():
		ui.hide()

func switch(str:String):
	hide_all()
	if UI.has(str):
		current = str
		UI[str].show()
	else:
		current = ''

func _show(str:String):
	if UI.has(str):
		UI[str].show()

func _physics_process(_delta: float) -> void:
	if (current == '' and G.in_game) or G.force_show_interaction_button:
		_show('joypad')
	else:
		_hide('joypad')

func _hide(str:String):
	if UI.has(str):
		UI[str].hide()
