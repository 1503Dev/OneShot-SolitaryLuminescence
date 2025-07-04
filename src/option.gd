extends Node

var option:= {
	language = 'en-US',
	default_movement = 'walk',
	read_the_instractions = false
}

func save():
	var file = FileAccess.open('user://options.oneshot', FileAccess.WRITE)
	if file:
		file.store_var(option)
		file.close()
	else:
		push_error("Failed to save options.")
	_update()

func _update():
	TranslationServer.set_locale(option.language)

func _ready() -> void:
	var file:= FileAccess.open('user://options.oneshot', FileAccess.READ)
	if FileAccess.file_exists('user://options.oneshot') and file:
		var saved_option:Dictionary = file.get_var()
		for key in saved_option.keys():
			option[key] = saved_option[key]
		file.close()
	else:
		push_error("Failed to load options, using defaults.")
	_update()
