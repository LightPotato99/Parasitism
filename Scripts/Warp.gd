extends Node2D

@export_file("*.tscn") var warp_to: String = ""
var warping: bool = false
@export var warpPoint: Vector2 = Vector2.ZERO

func _on_area_2d_body_entered(body):
	var isPlayer = body.is_in_group('player')
	var isInfectedHost = body.is_in_group('host') and body.curInfectState == body.InfectState.INFECTED
	if warp_to != "" and (isPlayer or isInfectedHost):
		ScreenTransition.change_level(warp_to)
		GLOBAL_GAME.warpPoint = warpPoint
	body.queue_free()
