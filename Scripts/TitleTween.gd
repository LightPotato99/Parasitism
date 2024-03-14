extends Sprite2D

var pos:Vector2

func _ready():
	pos = position
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", position + Vector2(0,15), 2).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.1)
	tween.tween_property(self, "position", position + Vector2(0,-15), 2).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.1)
