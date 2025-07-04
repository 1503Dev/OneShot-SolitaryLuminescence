extends Node

func _ready() -> void:
	var game:= G.load_game()
	if !game:
		SceneChanger.change('title', true)
	else:
		G.continue_game()
