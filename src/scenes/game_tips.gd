extends Control
@onready var sound_effect: SoundEffect = $SoundEffect
@onready var tip_1: TextureRect = $Tip1
@onready var tip_2: TextureRect = $Tip2

func _ready() -> void:
	G.force_show_interaction_button = true
	tip_1.show()
	tip_2.hide()
	sound_effect.play('instruction1')

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('interact') and !SceneChanger.changing:
		if tip_1.visible:
			SceneChanger.fade_in()
			sound_effect.play('instruction2')
			tip_2.show()
			tip_1.hide()
			SceneChanger.fade_out()
		elif tip_2.visible:
			G.force_show_interaction_button = false
			G.new_game()
