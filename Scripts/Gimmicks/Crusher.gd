extends HostEntity

@export var maxSpeed = 400
@export var acceleration = 12
@export var detectDist = 1000
@export var jumpBoost:float = 100
var originJumpVel = 0

@onready var ray:ShapeCast2D = $ShapeCast2D
@onready var reactivateTimer:Timer = $ReactivateTimer

var crusherLandParti := preload("res://Objects/Effects/CrusherLandParti.tscn")

var velocity:Vector2
var direction:Vector2
var speed:float = 0
enum State {IDLE,MOVING,CRUSHED}
var curState:int = State.IDLE

var dirArray = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

func _ready():
	originJumpVel = jumpVelocity
	$ShapeCast2D.visible = true

func _physics_process(delta):
	position += velocity * delta
	jumpVelocity = originJumpVel + velocity.y * jumpBoost
	
	if curState == State.IDLE:
		for i in range(4):
			ray.target_position = dirArray[i] * detectDist
			ray.force_shapecast_update()
			if ray.is_colliding() == true and ray.get_collider(0).is_in_group('player'):
				curState = State.MOVING
				direction = dirArray[i]
				speed = 0
				$Sprite2D.frame = i+1
				break
				
	if curState == State.MOVING:
		speed = move_toward(speed,maxSpeed,acceleration)
		velocity = speed * direction
		set_sync_to_physics(false)
		var wallCollision = move_and_collide(speed*direction*delta, true)
		set_sync_to_physics(true)
		if wallCollision and not wallCollision.get_collider().is_in_group('player') and not wallCollision.get_collider().is_in_group('host'):
			curState = State.CRUSHED
			if velocity.x != 0:
				position.x = snapped(position.x-16,32)+16
			if velocity.y != 0:
				position.y = snapped(position.y-16,32)+16
			velocity = Vector2.ZERO
			crush()
			reactivateTimer.start(0.1)
	
	if curState == State.CRUSHED:
		if reactivateTimer.is_stopped():
			curState = State.IDLE

func crush():
	$Sprite2D.frame = 0
	var crushParti = crusherLandParti.instantiate()
	crushParti.process_material.emission_shape_offset.x = direction.x * 16
	crushParti.process_material.emission_shape_offset.y = direction.y * 16
	crushParti.process_material.emission_shape_scale.x = direction.y * 16
	crushParti.process_material.emission_shape_scale.y = direction.x * 16
	crushParti.process_material.direction.x = direction.x * (-3)
	crushParti.process_material.direction.y = direction.y * (-3)
	add_child(crushParti)
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.crusherLand)
	
func _on_tree_exiting():
	if ScreenTransition.playing == false and onCamera:
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.bulletDestroy)
