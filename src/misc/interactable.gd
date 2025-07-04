extends Area2D
class_name Interactable

@export var actor:Node
@export var action:= ''
@export var direction:Niko.Direction = Niko.Direction.UP

func _on_body_entered(niko: Niko) -> void:
	niko.interacting_with = self

func _on_body_exited(niko: Niko) -> void:
	niko.interacting_with = null

func interact(niko: Niko) -> void:
	if actor and !action.is_empty():
		var niko_pos:= niko.position
		var niko_direction:= niko.get_direction()
		var can_act:= false
		if niko_direction == direction: can_act = true
		if !actor.has_method('act'): return
		if can_act:
			print(action)
			actor.act(action)
