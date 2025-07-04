extends Node2D
@onready var niko: CharacterBody2D = $Niko
@onready var animation_player_cg_wake: AnimationPlayer = $CanvasLayer_CG_Wake/CG_Wake/AnimationPlayer_CG_Wake
@onready var canvas_layer_cg_wake: CanvasLayer = $CanvasLayer_CG_Wake
@onready var timer_animation: Timer = $Timer_Animation
@onready var bgm: AudioStreamPlayer = $BGM
@onready var dialog: Dialog = $Dialog
@onready var tower_scenery: StaticBody2D = $TowerScenery
@onready var timer_animation_2: Timer = $Timer_Animation2

func _ready() -> void:
	G.game.scene = 'scenes/summit'
	G.stop_bgm()
	# G.can_exit = true
	if G.continued and G.game.has('niko'):
		niko.position = G.game.niko.position
	G.can_interact = false
	G.can_exit = false
	G.can_open_gui = false
	G.can_teleport = false
	if !G.game.has('woke_up') or !G.game.woke_up:
		animation_player_cg_wake.play('cg_wake')
		timer_animation.start()
		timer_animation_2.start()
		niko.camera.scale.x = 4.5
		niko.camera.scale.y = 4.5
		await animation_player_cg_wake.animation_finished
	canvas_layer_cg_wake.hide()
	if !G.is_bgm_playing():
		G.play_bgm('SomeplaceIKnow')
	G.game.woke_up = true
	await G.sleep(1)
	if !G.is_read(0):
		dialog.open([
			{
				who = 'niko3',
				text = 0,
				goto = 1
			},
			{
				id = 1,
				who = 'niko4',
				text = [1, '1.1'],
				options = [
					{
						text = 'yes',
						goto = '2.1'
					},
					{
						text = 'no',
						goto = '2.2'
					}
				]
			},
			{
				id = '2.1',
				who = 'niko_speak',
				text = [4, 2],
				goto = 3
			},
			{
				id = '2.2',
				who = 'niko',
				text = [3, 2],
				goto = 3
			},
			{
				id = 3,
				who = 'niko',
				text = 5
			}
		], 0)
	else:
		G.can_interact = true
		G.can_exit = true
		G.can_open_gui = true
	
	G.continued = false
	G._on_scene_ready()


func _on_timer_animation_timeout() -> void:
	niko.camera_animation_player.play('scale')

func act(action:String):
	print(action)
	match action:
		'sun':
			dialog.open([
				{
					who = 'niko',
					text = 6,
					goto = 0
				},
				{
					id = 0,
					text = 7
				}
			])
		'look_down':
			dialog.open([
				{
					who = 'niko',
					text = 8
				}
			])
		'scenery':
			G.disable_interaction()
			await tower_scenery.open()
			SceneChanger.change('scenes/elevator_to_start')


func _on_timer_animation_2_timeout() -> void:
	G.play_bgm('SomeplaceIKnow')
