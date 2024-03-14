extends Button

@export var window = Control

func _on_pressed():
	window.visible = !window.visible
