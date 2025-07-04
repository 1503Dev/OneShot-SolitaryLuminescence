extends Node

var scenes:= {
	'barrens': preload('res://src/scenes/barrens.tscn').instantiate(),
	'barrens_1': preload('res://src/scenes/barrens_1.tscn').instantiate(),
}

var loaded:= []
var current:= ''

func _ready():
	pass
func _input(event):
	if Input.is_action_just_pressed('debug'):
		switch('barrens_1')
	if Input.is_action_just_pressed('debug2'):
		switch('barrens')

func switch(scene:String, target_pos = null, direction = null):
	if current != scene:
		if current != '': remove_child(scenes[current])
		add_child(scenes[scene])
		if target_pos:
			scenes[scene].niko.position = target_pos
		if direction:
			scenes[scene].niko.direction = direction
		if scenes[scene].has_method('_resume') and scene in loaded:
			scenes[scene]._resume()
		if scene not in loaded:
			loaded.append(scene)
		current = scene
