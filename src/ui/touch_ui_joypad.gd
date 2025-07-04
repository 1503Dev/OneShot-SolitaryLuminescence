extends Control
@onready var movement: Control = $Movement
@onready var toolbar: Control = $Toolbar
@onready var interaction: Control = $Interaction

func _physics_process(_delta: float) -> void:
	if G.can_interact:
		movement.show()
	else:
		movement.hide()
	if G.can_open_gui and G.can_interact:
		toolbar.show()
	else:
		toolbar.hide()
