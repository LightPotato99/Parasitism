class_name HostEntity
extends AnimatableBody2D

@export var jumpVelocity = -550
@export var type:GLOBAL_GAME.HostType

enum InfectState {FREE,TARGETED,INFECTED}
var curInfectState = InfectState.FREE
var createPlayer := preload("res://Objects/Character.tscn")
var castOutParti := preload("res://Objects/Effects/CastOutParti.tscn")
var hostDestroyParti := preload("res://Objects/Effects/HostDestroyParti.tscn")
var deathParti := preload("res://Objects/Effects/CastOutParti.tscn")
var castTrail = preload("res://Objects/Effects/CastTrail.tscn")
var hostable:bool = true
var onCamera:bool = false
var whiteness:float = 0

func _process(_delta):
	onCamera = $HostElement/VisibleOnScreenNotifier2D.is_on_screen()
	$HostElement/TargetSprite.visible = (curInfectState == InfectState.TARGETED)
	$HostElement/InfectParticle.visible = (curInfectState == InfectState.INFECTED)
		
	if curInfectState == InfectState.INFECTED:
		if Input.is_action_just_pressed("ui_accept"):
			jump_out()
		if Input.is_action_just_pressed("restart"):
			delete_host(false)
			
	$Sprite2D.material.set_shader_parameter('whiteness',whiteness)
	whiteness = lerp(whiteness,0.0,0.3)
			
func get_infected(trailPos):
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.cast)
	curInfectState = InfectState.INFECTED
	get_node("/root/Node2D/Camera").target = self
	var trail = castTrail.instantiate()
	trail.posFollow = trailPos
	add_child(trail)
	whiteness = 1

	
func jump_out():
	var playerInst = createPlayer.instantiate()
	get_parent().get_parent().add_child(playerInst)
	playerInst.position = position
	playerInst.velocity.y = jumpVelocity
	playerInst.add_child(castOutParti.instantiate())
	get_node("/root/Node2D/Camera").shake_screen(15,15)
	get_node("/root/Node2D/Camera").target = playerInst
	GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.castOut)
	delete_host(true)

func delete_host(jumpedOut:bool):
	var destroyP = hostDestroyParti.instantiate()
	destroyP.position = global_position
	get_parent().add_child(destroyP)
	queue_free()
	if curInfectState == InfectState.INFECTED and not jumpedOut:
		ScreenTransition.restart_level()
		var deathP = deathParti.instantiate()
		deathP.position = global_position
		get_parent().add_child(deathP)
		get_node("/root/Node2D/Camera").shake_screen(15,10)
		GLOBAL_SOUNDS.play_sound(GLOBAL_SOUNDS.death)
