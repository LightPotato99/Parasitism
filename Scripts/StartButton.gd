extends Button

@export_file("*.tscn") var warp_to: String = ""

func _on_pressed():
	ScreenTransition.change_level(warp_to)
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.gameStart)
	GLOBAL_GAME.timeFlow = true

func _on_mouse_entered():
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.buttonSelect)
