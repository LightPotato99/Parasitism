extends Line2D

var posFollow:Vector2

func _process(_delta):
	clear_points()
	var posCenter = get_parent().position
	add_point(posCenter)
	add_point(posFollow)
	posFollow = lerp(posFollow,posCenter,0.2)

func _on_timer_timeout():
	queue_free()
