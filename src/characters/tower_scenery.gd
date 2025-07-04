extends StaticBody2D
class_name TowerScenery
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sound_effect: SoundEffect = $SoundEffect
@onready var tower_scenery: Sprite2D = $TowerScenery

var opened:= false
var is_ready:= true

func open():
	if opened: return
	is_ready = false
	opened = true
	animation_player.play('open')
	sound_effect.play('elevator_open')
	await animation_player.animation_finished
	tower_scenery.hide()
	collision_shape_2d.disabled = true
	is_ready = true

func _open():
	opened = true
	tower_scenery.hide()
	tower_scenery.frame = 0

func close():
	if not opened: return
	is_ready = false
	opened = false
	sound_effect.play('elevator_close')
	await G.sleep(0.333)
	tower_scenery.show()
	animation_player.play_backwards('open')
	await animation_player.animation_finished
	collision_shape_2d.disabled = false
	await sound_effect.finished
	is_ready = true
