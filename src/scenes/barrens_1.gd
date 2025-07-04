extends Node2D
@onready var niko: Niko = $Niko
@onready var dialog: Dialog = $Dialog
@onready var sound_effect: SoundEffect = $SoundEffect

var logon:= false

func _ready() -> void:
	if G.continued and G.game.has('niko'):
		niko.position = G.game.niko.position
	_resume()
	G._on_scene_ready()

func _resume():
	G.game.scene = 'barrens_1'
	G.continued = false
	G.can_teleport = false
	if G.get_bgm() != 'Phosphor' or !G.is_bgm_playing():
		G.play_bgm('Phosphor')
	G.enable_interaction()

func act(a):
	match a:
		'endport':
			dialog.open([
				{
					who = 'niko',
					text = 20
				}
			])
		'out':
			G.disable_interaction()
			SceneChanger.change('barrens',false, Vector2(3167, 5145), Niko.Direction.DOWN)
