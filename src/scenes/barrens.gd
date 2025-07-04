extends Node2D
@onready var niko: Niko = $Niko
@onready var dialog: Dialog = $Dialog
@onready var sound_effect: SoundEffect = $SoundEffect

func _ready() -> void:
	if G.continued and G.game.has('niko'):
		niko.position = G.game.niko.position
	_resume()
	G._on_scene_ready()

func _resume():
	G.game.scene = 'barrens'
	G.continued = false
	G.can_teleport = true
	if G.get_bgm() != 'Phosphor' or !G.is_bgm_playing():
		G.play_bgm('Phosphor')
	G.enable_interaction()

func act(a):
	match a:
		'into_1':
			G.disable_interaction()
			SceneChanger.change('barrens_1', false, Vector2(3392, 5040), Niko.Direction.DOWN)
