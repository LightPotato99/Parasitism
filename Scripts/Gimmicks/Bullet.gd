extends HostEntity

var velocity:Vector2
var direction:Vector2
var speed:float
var justFired:float = 1

var dirArray = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var bulSound = preload("res://Objects/Gimmicks/BulletSound.tscn")

func _ready():
	velocity = direction * speed
	if velocity.x < 0:
		$Sprite2D.scale.x = -1
	
func _physics_process(delta):
	if curInfectState == InfectState.INFECTED:
		var verticalDir = Input.get_axis("ui_up", "ui_down")
		if verticalDir:
			velocity.y = verticalDir * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed*2)
		
	position += velocity * delta
	
	justFired -= 0.2
	if justFired < 0:
		pass

func _on_bounce_area_body_entered(body):
	body.player_jump(-500,false)
	hostable = false
	delete_host(false)
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.bulletDestroy)

func _on_wall_col_area_body_entered(body):
	if not body.is_in_group('bullet'):
		var snd = bulSound.instantiate()
		snd.position = global_position
		get_parent().add_child(snd)
		delete_host(false)

func _on_tree_exited():
	pass

func _on_tree_exiting():
	if ScreenTransition.playing == false and onCamera and curInfectState == InfectState.INFECTED:
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.bulletDestroy)
	
