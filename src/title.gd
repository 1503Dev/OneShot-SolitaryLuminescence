extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var action_disabled:= false

func _ready() -> void:
	SettingsLayout.title = self
	await get_tree().create_timer(0.9).timeout
	G.can_exit = true
	G.play_bgm('MyBurdenIsLight')

func act(action:String):
	if action_disabled: return
	match action:
		'exit':
			action_disabled = true
			animation_player.play("fade_out")
			await animation_player.animation_finished
			get_tree().quit()
		'settings':
			action_disabled = true
			SettingsLayout.open()
		'start':
			action_disabled = true
			if !Option.option.read_the_instractions:
				SceneChanger.change('scenes/game_tips')
			else:
				G.new_game()
