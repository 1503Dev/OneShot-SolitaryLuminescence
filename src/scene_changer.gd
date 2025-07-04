extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var changing:= false

const INNER_SCENES:= [
	'global',
	'scene_changer',
	'scene_manager',
	'splash',
	'title',
	'empty'
]

func _ready() -> void:
	hide()
	#z_index = 1503

func change(path:String, skip:= false, target_pos = null, direction = null):
	show()
	changing = true
	if !skip:
		animation_player.play("fade_in")
		await animation_player.animation_finished
	if path == 'scenes/barrens_1': path = 'barrens_1'
	if !path.contains('scenes/'):
		if path in INNER_SCENES:
			G.change_scene(path)
		else:
			G.change_scene('empty')
			SceneManager.switch(path, target_pos, direction)
	else:
		G.change_scene(path)
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	changing = false
	hide()

func fade_in():
	changing = true
	animation_player.play("fade_in")
	show()
	await animation_player.animation_finished

func fade_out():
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	changing = false
	hide()
