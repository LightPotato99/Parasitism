extends Area2D

@export var colNum = 0
var keycardGetParti := preload("res://Objects/Effects/KeycardGetParti.tscn")

func _ready():
	if GLOBAL_GAME.collectibles[colNum] == GLOBAL_GAME.ColState.GET:
		queue_free()
		
func _process(_delta):
	if GLOBAL_GAME.collectibles[colNum] == GLOBAL_GAME.ColState.GET:
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.keycardGet)
		var cardP = keycardGetParti.instantiate()
		cardP.position = global_position
		get_parent().add_child(cardP)
		queue_free()
		
func _on_body_entered(_body):
	if GLOBAL_GAME.collectibles[colNum] == GLOBAL_GAME.ColState.NONE:
		GLOBAL_GAME.collectibles[colNum] = GLOBAL_GAME.ColState.PENDING
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.redKeycardPending)
		modulate.a = 0.4
