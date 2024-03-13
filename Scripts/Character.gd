extends CharacterBody2D

@onready var shapeCast:ShapeCast2D = $ShapeCast2D
@onready var castParti:GPUParticles2D = $GPUParticles2D
@onready var coyoteTimer:Timer = $timers/CoyoteTimer
@onready var jumpBufferTimer:Timer = $timers/JumpBufferTimer
@onready var hostBufferTimer:Timer = $timers/HostBufferTimer
@onready var anim:AnimationPlayer = $AnimationPlayer

@export var hostDetectRadius = 60

const SPEED = 270.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumpsLeft = 2
var jumpBuffered:bool = false

enum PlayerState {IDLE,JUMP,WALK}
var curPlayerState = PlayerState.IDLE

var hostBuffered:bool = false
var host = null

var deathParti := preload("res://Objects/Effects/CastOutParti.tscn")
var djumpParti := preload("res://Objects/Effects/DJumpParti.tscn")
var landParti := preload("res://Objects/Effects/LandParti.tscn")

func _ready():
	shapeCast.shape.radius = hostDetectRadius
	castParti.process_material.emission_ring_radius = hostDetectRadius
	castParti.process_material.emission_ring_inner_radius = hostDetectRadius-1
	
	if ScreenTransition.playing and GLOBAL_GAME.warpPoint != Vector2.ZERO:
		position = GLOBAL_GAME.warpPoint

func _physics_process(delta):
	$GPUParticles2D.visible = GLOBAL_GAME.infectAble[0]
	if ScreenTransition.playing:
		return
	
	#gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if curPlayerState != PlayerState.JUMP:
			coyoteTimer.start(0.05)
		curPlayerState = PlayerState.JUMP
		if coyoteTimer.is_stopped():
			jumpsLeft = min(jumpsLeft,1)
			
	#jump
	if Input.is_action_just_pressed("ui_accept"):
		jumpBuffered = true
		jumpBufferTimer.start(0.05)
	if jumpBufferTimer.is_stopped():
		jumpBuffered = false
	if jumpBuffered and jumpsLeft > 0:
		player_jump(JUMP_VELOCITY,true)
	elif is_on_floor():
		if jumpsLeft < 2:
			anim.play('land')
			add_child(landParti.instantiate())
			GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.land)
		jumpsLeft = 2
		curPlayerState = PlayerState.IDLE
		if !anim.is_playing():
			anim.play('idle')
		
	$DJumpIndicator.visible = jumpsLeft == 1

	#move
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			anim.play('walk_left')
		else:
			anim.play('walk_right')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#parasite gimmick
	if Input.is_action_just_pressed("cast"):
		hostBuffered = true
		hostBufferTimer.start(0.05)
	if hostBufferTimer.is_stopped():
		hostBuffered = false
		
	var collisions = shapeCast.collision_result
	for res in collisions:
		if res.collider != null and GLOBAL_GAME.infectAble[res.collider.type] and host == null:
			host = res.collider
			break
			
	if host != null:
		host.curInfectState = host.InfectState.TARGETED
		var casted = false
		if hostBuffered and host.hostable:
			host.get_infected(global_position)
			casted = true
			queue_free()
		if shapeCast.is_colliding() == false and !casted:
			host.curInfectState = host.InfectState.FREE
			host = null
		
	if Input.is_action_just_pressed("restart"):
		kill_player()

func player_jump(jumpVel,consumeDjump):
	velocity.y = jumpVel
	if jumpsLeft == 2:
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.jump)
	if jumpsLeft == 1:
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.dJump)
		add_child(djumpParti.instantiate())
	if consumeDjump:
		jumpsLeft -= 1
	jumpBuffered = false
	anim.play('jump')
		
func kill_player():
	get_node("/root/Node2D/Camera").shake_screen(15,10)
	var deathP = deathParti.instantiate()
	deathP.position = global_position
	get_parent().add_child(deathP)
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.death)
	GLOBAL_GAME.reset_collectibles()
	ScreenTransition.restart_level()
	queue_free()
	
func _on_is_crushed_body_entered(body):
	if not body.is_in_group('player'):
		kill_player()

func _on_killer_body_entered(_body):
	kill_player()
