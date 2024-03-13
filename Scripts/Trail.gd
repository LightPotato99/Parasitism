extends Line2D

var queue:Array
@export var MAX_LENGTH:int

func _process(_delta):
	queue.push_front(get_parent().position)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	clear_points()
	
	for point in queue:
		add_point(point)
