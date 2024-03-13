extends Area2D

@export var isVisible:bool = true

func _ready():
	if not isVisible:
		$Sprite2D.visible = false

func _on_body_entered(body):
	body.player_jump(-500,false)
