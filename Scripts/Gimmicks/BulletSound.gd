extends AudioStreamPlayer2D

func _process(_delta):
	if not is_playing:
		queue_free()
