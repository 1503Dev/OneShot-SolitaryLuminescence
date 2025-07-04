extends Node2D
@onready var niko: Niko = $Niko
@onready var dialog: Dialog = $Dialog
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var ad_finitum: TextureRect = $CanvasLayer/Ad_Finitum
@onready var ad_finitum_animation_player: AnimationPlayer = $CanvasLayer/Ad_Finitum/AnimationPlayer
@onready var sound_effect: SoundEffect = $SoundEffect
@onready var incorrect_password: ColorRect = $CanvasLayer/IncorrectPassword
@onready var login: ColorRect = $CanvasLayer/Login
@onready var line_edit: LineEdit = $CanvasLayer/Login/LineEdit
@onready var pc: ColorRect = $CanvasLayer/PC

var logon:= false

func _ready() -> void:
	G.game.scene = 'scenes/start'
	if G.continued and G.game.has('niko'):
		niko.position = G.game.niko.position
	if G.continued and G.game.has('start'):
		logon = G.game.start.login
	G.continued = false
	G.can_teleport = false
	if !G.is_bgm_playing():
		G.play_bgm('SomeplaceIKnow')
	G.enable_interaction()
	ad_finitum.hide()
	incorrect_password.hide()
	login.hide()
	canvas_layer.hide()
	pc.hide()
	G._on_scene_ready()

func act(a):
	match a:
		'out':
			G.disable_interaction()
			if !logon:
				sound_effect.play('door_locked')
				await sound_effect.finished
				dialog.open([{
					who = 'niko',
					text = 16
				}])
			else:
				sound_effect.play('door_open')
				SceneChanger.change('barrens_1')
		'window':
			dialog.open([
				{
					who = 'niko',
					text = G.randi(14, 15)
				}
			])
		'book':
			G.disable_interaction()
			ad_finitum_animation_player.play('fade_in')
			ad_finitum.show()
			canvas_layer.show()
			sound_effect.play('page')
			await ad_finitum_animation_player.animation_finished
			await G.interacted
			ad_finitum_animation_player.play_backwards('fade_in')
			await ad_finitum_animation_player.animation_finished
			canvas_layer.hide()
			ad_finitum.hide()
			G.enable_interaction()
		'bed':
			dialog.open([
				{
					who = 'niko',
					text = 17,
					goto = 0
				},
				{
					id = 0,
					text = 18
				}
			])
		'pc':
			G.disable_interaction()
			sound_effect.play('pc_on')
			await G.sleep(1)
			if logon:
				dialog.open([
					{
						who = 'niko',
						text = 19
					}
				])
			else:
				canvas_layer.show()
				login.show()
				line_edit.clear()
				line_edit.grab_focus()

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.strip_edges().to_lower().replace(' ', '') == 'adfinitum':
		logon = true
		sound_effect.play('pc_granted')
		login.hide()
		pc.show()
		line_edit.clear()
		await G.sleep(1)
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.1'))
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.2'))
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.3'))
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.5'))
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.6'))
		sound_effect.play('pc_messagebox')
		G.alert(tr('dialog.wm.7') % G.get_player_name())
		await G.sleep(1)
		pc.hide()
		canvas_layer.hide()
		sound_effect.play('pc_off')
		G.enable_interaction()
		await sound_effect.finished
		sound_effect.play('door_unlock')
		if !G.game.has('start'): G.game.start = {}
		G.game.start.login = true

func _on_line_edit_text_submitted(new_text: String) -> void:
	if logon: return
	if new_text.strip_edges().to_lower().replace(' ', '') != 'adfinitum':
		login.hide()
		sound_effect.play('pc_denied')
		incorrect_password.show()
		await G.sleep(1.5)
		incorrect_password.hide()
		canvas_layer.hide()
		G.enable_interaction()
