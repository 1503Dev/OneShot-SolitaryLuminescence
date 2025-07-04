extends Control

@onready var border: Control = $Border
@onready var label: Label = $Label

var on_click:= func():
	pass

func _on_texture_button_mouse_entered() -> void:
	border.show()

func _on_texture_button_mouse_exited() -> void:
	border.hide()

func _ready() -> void:
	border.hide()

func set_text(text:String):
	label.text = text

func set_on_click(_cb:Callable):
	on_click = func():
		hide()
		$"..".hide()
		for node in get_parent().get_children():
			if node: node.hide()
		_cb.call()

func _on_texture_button_pressed() -> void:
	on_click.call()
