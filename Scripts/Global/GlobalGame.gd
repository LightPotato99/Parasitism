extends Node

var infectAble = [false,false]
enum HostType {CRUSHER,BULLET}
var warpPoint: Vector2 = Vector2.ZERO
var deaths:int = 0
var time:float = 0
var timeFlow:bool = false
var timeText:String = "a"

enum ColState {NONE,PENDING,GET}
var collectibles = [0,0,0]

func _process(delta):
	if timeFlow:
		time += delta
	@warning_ignore("integer_division")
	var minute = int(time) / 60
	var sec = int(time) % 60
	var leadZero = (int(time) % 60) < 10
	if leadZero:
		timeText = str(minute) + ":" + "0" + str(sec)
	else:
		timeText = str(minute) + ":" + str(sec)
	
func reset_collectibles():
	for i in range(3):
		if collectibles[i] == ColState.PENDING:
			collectibles[i] = ColState.NONE

func collect_items():
	for i in range(3):
		if collectibles[i] == ColState.PENDING:
			collectibles[i] = ColState.GET
