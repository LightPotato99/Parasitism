extends Button

@export_file("*.tscn") var warp_to: String = ""

func _on_pressed():
	ScreenTransition.change_level(warp_to)
