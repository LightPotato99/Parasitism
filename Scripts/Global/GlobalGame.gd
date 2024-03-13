extends Node

var infectAble = [false,false]
enum HostType {CRUSHER,BULLET}
var warpPoint: Vector2 = Vector2.ZERO

enum ColState {NONE,PENDING,GET}
var collectibles = [0,0,0]

func _ready():
	pass
	#for i in range(HostType.size()):
	#	infectAble.append(false)
		
func reset_collectibles():
	for i in range(3):
		if collectibles[i] == ColState.PENDING:
			collectibles[i] = ColState.NONE

func collect_items():
	for i in range(3):
		if collectibles[i] == ColState.PENDING:
			collectibles[i] = ColState.GET
