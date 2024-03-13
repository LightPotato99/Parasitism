extends Area2D

func _on_body_entered(_body):
	GLOBAL_GAME.warpPoint = position
	GLOBAL_GAME.collect_items()
