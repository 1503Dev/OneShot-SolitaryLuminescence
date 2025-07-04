extends StaticBody2D
class_name NPC

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var direction_text:= 'down'

@export var tile_map_layer: TileMapLayer
@export var direction:= Direction.DOWN:
	set(v):
		direction = v
		match v:
			Direction.UP:
				direction_text = 'up'
			Direction.DOWN:
				direction_text = 'down'
			Direction.LEFT:
				direction_text = 'left'
			Direction.RIGHT:
				direction_text = 'right'
