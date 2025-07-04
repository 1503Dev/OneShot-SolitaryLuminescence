extends Node2D
@onready var tower_scenery: TowerScenery = $Objects/TowerScenery
@onready var sound_effect: SoundEffect = $SoundEffect
@onready var niko: Niko = $Niko
@onready var dialog: Dialog = $Dialog

func _ready() -> void:
	G.continued = false
	G.game.scene = 'scenes/elevator_to_start'
	G.can_interact = false
	G.can_exit = false
	G.can_open_gui = false
	G.can_teleport = false
	tower_scenery._open()
	await tower_scenery.close()
	sound_effect.play('elevator_start')
	niko.camera_animation_player.play('elevator_shake_start')
	await sound_effect.finished
	G.can_interact = true
	dialog.open([
		{
			who = 'niko_distressed',
			text = 9,
			options = [
				{
					text = 'opt.idk',
					goto = 0
				}
			]
		},
		{
			id = 0,
			text = [10, 10.1],
			who = 'niko_eyeclosed2',
			goto = 1
		},
		{
			id = 1,
			text = 11,
			goto = 2
		},
		{
			id = 2,
			who = 'niko_sad',
			text = [12, 12.1],
			goto = 3
		},
		{
			id = 3,
			who = 'niko_cry',
			text = 13
		}
	])
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake')
	await niko.camera_animation_player.animation_finished
	niko.camera_animation_player.play('elevator_shake_end')
	await niko.camera_animation_player.animation_finished
	await G.sleep(0.5)
	tower_scenery.open()

func act(_a):
	if tower_scenery.ready and tower_scenery.opened:
		G.can_interact = false
		SceneChanger.change('scenes/attic')

func _physics_process(delta: float) -> void:
	G.can_exit = false
