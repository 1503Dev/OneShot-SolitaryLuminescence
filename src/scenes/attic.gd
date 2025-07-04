extends Node2D
@onready var niko: Niko = $Niko
@onready var dialog: Dialog = $Dialog
@onready var tower_scenery: TowerScenery = $Objects/TowerScenery
@onready var sound_effect: SoundEffect = $SoundEffect

func _ready() -> void:
	G.game.scene = 'scenes/attic'
	if G.continued and G.game.has('niko'):
		niko.position = G.game.niko.position
	if !G.is_bgm_playing():
		G.play_bgm('SomeplaceIKnow')
	if !G.continued:
		tower_scenery._open()
		await tower_scenery.close()
	G.continued = false
	G.enable_interaction()
	G._on_scene_ready()

func act(a):
	match a:
		'out':
			sound_effect.play('door_open')
			SceneChanger.change('scenes/start')
		'window':
			dialog.open([
				{
					who = 'niko',
					text = G.randi(14, 15)
				}
			])
		'door':
			G.disable_interaction()
			sound_effect.play('door_locked')
			await sound_effect.finished
			dialog.open([
				{
					who = 'niko',
					text = 16
				}
			])
