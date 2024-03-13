extends Area2D

@export var type:GLOBAL_GAME.HostType
var keycardGetParti := preload("res://Objects/Effects/KeycardGetParti.tscn")

func _ready():
	if GLOBAL_GAME.infectAble[type]:
		queue_free()
		
func _on_body_entered(_body):
	GLOBAL_GAME.infectAble[type] = true
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.keycardGet)
	var cardP = keycardGetParti.instantiate()
	cardP.position = global_position
	get_parent().add_child(cardP)
	queue_free()
