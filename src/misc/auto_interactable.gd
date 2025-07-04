extends Interactable
class_name AutoInteractable

var interacted:= false

func _on_body_entered(niko: Niko) -> void:
	super._on_body_entered(niko)
	if interacted: return
	interacted = true
	get_tree().create_timer(0.5).timeout.connect(func():
		interacted = false
	)
	interact(niko)
