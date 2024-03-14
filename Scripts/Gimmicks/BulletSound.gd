extends AudioStreamPlayer2D

func _process(delta):
	if not is_playing:
		queue_free()
