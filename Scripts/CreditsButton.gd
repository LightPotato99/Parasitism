extends Button

@export var window = Control

func _on_pressed():
	window.visible = !window.visible

func _on_mouse_entered():
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.buttonSelect)
