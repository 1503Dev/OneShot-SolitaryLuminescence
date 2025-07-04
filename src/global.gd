extends Node

@onready var bgm: AudioStreamPlayer = $BGM

var can_exit:= false
var can_open_gui:= false
var can_teleport:= false
var in_game:= false
var can_interact:= false

var scene:= 'splash'
var game:= {}
var niko:CharacterBody2D
var player_name:= ''
var continued:= false
var bgm_name:= ''
var force_show_interaction_button:= false

signal interacted

func change_scene(path:String):
	scene = path
	get_tree().change_scene_to_file('res://src/' + path + '.tscn')

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_en'):
		TranslationServer.set_locale('en-US')
	if Input.is_action_just_pressed('debug_zh'):
		TranslationServer.set_locale('zh-CN')
	if Input.is_action_just_pressed('fullscreen'):
		var window = DisplayServer.window_get_mode()
		if window == DisplayServer.WINDOW_MODE_FULLSCREEN or window == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	if Input.is_action_just_pressed('interact'):
		interacted.emit()
	if event is InputEventKey and event.keycode == KEY_BACK and event.is_pressed():
		_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func opt(key:String, value):
	print('Opt, ' + key + ' = ' + str(value))
	Option.option[key] = value
	Option.save()

func _ready() -> void:
	TranslationServer.set_locale('en-US')

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if !can_exit:
			alert(tr('can_not_exit'))
		elif !in_game:
			get_tree().quit()
		else:
			DisplayServer.dialog_show(' ', tr('ask_save_and_exit'), [tr('yes'), tr('no')], func(index):
				if index == 0:
					game.left = true
					save_game()
					get_tree().quit()
			)
			
func new_game():
	opt('read_the_instractions', true)
	in_game = true
	if load_game():
		continue_game()
		return
	save_game()
	SceneChanger.change('scenes/summit')

func save_game():
	var file = FileAccess.open('user://save.oneshot', FileAccess.WRITE)
	if file:
		file.store_var(game)
		file.close()
	else:
		push_error("Failed to save options.")

func load_game() -> bool:
	var file:= FileAccess.open('user://save.oneshot', FileAccess.READ)
	if file:
		var saved_game:Dictionary = file.get_var()
		file.close()
		for key in saved_game.keys():
			game[key] = saved_game[key]
		return true
	else:
		return false

func continue_game():
	in_game = true
	continued = true
	if game.has('scene'):
		SceneChanger.change(game.scene, true)
	else:
		SceneChanger.change('scenes/summit', true)

func randi(_min:int, _max:int) -> int:
	return randi() % (_max - _min + 1) + _min

func is_read(id:int) -> bool:
	if game.has('read_dialog'):
		if game.read_dialog.has(id):
			return true
		else: game.read_dialog.push_back(id)
	else: game.read_dialog = [id]
	return false

func sleep(seconds:float = 1.0):
	await get_tree().create_timer(seconds).timeout

func get_player_name() -> String:
	if player_name == '':
		player_name = get_username()
	return player_name

func get_username() -> String:
	if OS.get_name() == "Android":
		return tr("player")
	else:
		if OS.get_environment("USERNAME"):
			return OS.get_environment("USERNAME")
		elif OS.get_environment("USER"):
			return OS.get_environment("USER")
		else:
			return tr("player")

func _on_scene_ready() -> void:
	if game.has('left') and game.left and (!game.has('sleeping') or !game.sleeping):
		WorldMachineDialog.open([0])
	game.left = false
	game.sleeping = false

func disable_interaction():
	can_interact = false
	can_open_gui = false
	can_exit = false

func enable_interaction():
	can_interact = true
	can_open_gui = true
	can_exit = true

func percent_to_db(percent: int) -> float:
	if percent <= 0:
		return -INF
	return 10 * log(float(percent) / 100.0)

func play_bgm(path:= ''):
	if !path.is_empty():
		bgm_name = path
		bgm.stream = load('res://src/audios/BGM/' + path + '.ogg')
	bgm.play()

func stop_bgm():
	bgm.stop()

func is_bgm_playing() -> bool:
	return bgm.playing

func _physics_process(_delta: float) -> void:
	if Option.option.has('bgm_volume'):
		bgm.volume_db = G.percent_to_db(Option.option.bgm_volume)

func alert(text:String):
	DisplayServer.dialog_show(' ', text, [tr('ok')], func():)

func get_bgm() -> String:
	return bgm_name
