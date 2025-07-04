extends CharacterBody2D
class_name Niko

const SPEED := 4.5
signal moved_to(origin_pos: Vector2, target_pos: Vector2)

var last_direction := "down"
var interacting_with: Interactable
var footstep_sounds := {
	tile = [
		'step_tile01',
		'step_tile02',
		'step_tile03',
		'step_tile04'
	],
	wood = 'step_wood',
	gravel = 'step_gravel'
}
const tile_type:= {
	wood = [
		'2,1,0',
		'2,2,0',
		'2,3,0',
		'2,1,1',
		'2,2,1',
		'2,3,1',
		'2,1,2',
		'2,2,2',
		'2,3,2',
		'2,1,3',
		'2,2,3',
		'2,3,3',
		'2,0,31',
		'2,1,31',
		'3,0,1',
		'3,1,1',
		'3,2,1',
		'3,0,2',
		'3,1,2',
		'3,2,2',
		'3,0,3',
		'3,1,3',
		'3,2,3',
		'5,0,1',
		'5,1,1',
		'5,2,1',
		'5,0,2',
		'5,1,2',
		'5,2,2',
		'5,0,3',
		'5,1,3',
		'5,2,3',
		'10,0,0',
		'10,1,0',
		'10,0,1',
		'10,1,1',
		'10,1,2',
		'10,2,2',
		'10,1,7',
		'10,2,7',
		'5,0,0'
	],
	gravel = [
		'6,1,0',
		'6,2,0',
		'6,3,0',
		'6,1,1',
		'6,2,1',
		'6,3,1',
		'6,1,2',
		'6,2,2',
		'6,3,2',
		'6,1,3',
		'6,2,3',
		'6,3,3'
	]
}
var is_moving_to_target := false
var move_target := Vector2.ZERO
var move_origin := Vector2.ZERO

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var tile_map_layer: TileMapLayer
@export var direction:= Direction.DOWN:
	set(v):
		direction = v
		match v:
			Direction.UP:
				last_direction = 'up'
			Direction.DOWN:
				last_direction = 'down'
			Direction.LEFT:
				last_direction = 'left'
			Direction.RIGHT:
				last_direction = 'right'
		if animation_player: animation_player.play('idle_' + last_direction)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var camera_animation_player: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var sprite: Sprite2D = $Niko
@onready var sprite_light: Sprite2D = $NikoLight
@onready var timer_footstep: Timer = $Timer_Footstep
@onready var sound_effect_footstep: SoundEffect = $SoundEffect_Footstep

func _physics_process(delta: float) -> void:
	if is_moving_to_target:
		_process_movement(delta)
		return
	
	var _speed := SPEED * delta * 1000
	var speed := _speed
	
	if Option.option.default_movement == 'run':
		speed *= 1.5
		timer_footstep.wait_time = 0.25
	else:
		timer_footstep.wait_time = 0.333
	if Input.is_action_pressed('run'):
		if Option.option.default_movement == 'walk':
			speed *= 1.5
			timer_footstep.wait_time = 0.25
		else:
			speed /= 1.5
			timer_footstep.wait_time = 0.333
	
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	if G.can_interact:
		if input_vector.x != 0:
			last_direction = "right" if input_vector.x > 0 else "left"
		if input_vector.y != 0:
			last_direction = "down" if input_vector.y > 0 else "up"
	
	velocity = Vector2.ZERO
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	
	var prev_position := global_position
	if G.can_interact: 
		move_and_slide()
	
	_update_animation(input_vector, prev_position)

func _process_movement(delta: float) -> void:
	var direction := (move_target - position).normalized()
	var distance := position.distance_to(move_target)
	var move_speed := SPEED * delta * 1000
	
	if distance < 5.0:
		position = move_target
		is_moving_to_target = false
		moved_to.emit(move_origin, move_target)
		return
	
	if direction.x != 0:
		last_direction = "right" if direction.x > 0 else "left"
	if direction.y != 0:
		last_direction = "down" if direction.y > 0 else "up"
	
	velocity = direction * move_speed
	var prev_position := position
	move_and_slide()
	
	if (position - prev_position).length() > 0.1:
		var move_anim := "move_" + last_direction
		if animation_player.has_animation(move_anim):
			animation_player.play(move_anim)
			footstep()

func _update_animation(input_vector: Vector2, prev_position: Vector2) -> void:
	var has_input := input_vector.length() > 0
	var actually_moved := (global_position - prev_position).length() > 0.1
	var is_sliding := is_on_floor() and velocity.length() > 0 and not actually_moved
	
	var move_anim := "move_" + last_direction
	var idle_anim := "idle_" + last_direction

	if !G.can_interact: 
		has_input = false
	
	if has_input:
		if actually_moved or is_sliding:
			if animation_player.has_animation(move_anim):
				animation_player.play(move_anim)
				footstep()
		else:
			if animation_player.has_animation(idle_anim):
				animation_player.play(idle_anim)
			elif animation_player.has_animation(move_anim):
				animation_player.play(move_anim)
				animation_player.seek(0, true)
				animation_player.stop()
	else:
		if animation_player.has_animation(idle_anim):
			animation_player.play(idle_anim)
		elif animation_player.has_animation(move_anim):
			animation_player.play(move_anim)
			animation_player.seek(0, true)
			animation_player.stop()
	
	sprite_light.frame = sprite.frame
	
	if !G.game.has('niko'): 
		G.game.niko = {}
	G.game.niko.position = position

func footstep():
	if timer_footstep.time_left <= 0:
		var tile_pos:= tile_map_layer.local_to_map(position)
		var tile_source:= tile_map_layer.get_cell_source_id(tile_pos)
		var tile_group_pos:= tile_map_layer.get_cell_atlas_coords(tile_pos)
		var sound_type:= 'tile'
		var symbol:= str(tile_source) + ',' + str(tile_group_pos.x) + ',' + str(tile_group_pos.y)
		if tile_type.wood.has(symbol):
			sound_type = 'wood'
		elif tile_type.gravel.has(symbol):
			sound_type = 'gravel'
		
		var footstep_sounds = footstep_sounds[sound_type]
		if footstep_sounds is String:
			sound_effect_footstep.play(footstep_sounds)
		else:
			sound_effect_footstep.play(
				footstep_sounds[G.randi(0, footstep_sounds.size() - 1)]
			)

		timer_footstep.start()

func rotation() -> String:
	return last_direction

func move_to(x: float, y: float) -> void:
	move_target = Vector2(x, y)
	move_origin = position
	is_moving_to_target = true
	G.can_interact = false

func _ready() -> void:
	G.niko = self
	if direction == Direction.RIGHT:
		last_direction = "right"
		animation_player.play('idle_right')
	elif direction == Direction.LEFT:
		last_direction = "left"
		animation_player.play('idle_left')
	elif direction == Direction.UP:
		last_direction = "up"
		animation_player.play('idle_up')
	elif direction == Direction.DOWN:
		last_direction = "down"
		animation_player.play('idle_down')

func _process(_delta: float) -> void:
	if G.can_interact and Input.is_action_just_pressed('interact') and interacting_with:
		interacting_with.interact(self)

func get_direction() -> Direction:
	match last_direction:
		'up': return Direction.UP
		'down': return Direction.DOWN
		'left': return Direction.LEFT
		'right': return Direction.RIGHT
	return Direction.UP
