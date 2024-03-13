extends StaticBody2D

@onready var cooldownTimer:Timer = $Timer
var bullet = preload("res://Objects/Gimmicks/Bullet.tscn")

@export var cooldown:float = 1
@export var speed:float = 200
enum Dir {LEFT,RIGHT}
@export var direction:Dir

func _ready():
	cooldownTimer.wait_time = cooldown
	cooldownTimer.start(cooldown)
	if direction == Dir.LEFT:
		$Sprite2D.scale.x = -1

func _on_timer_timeout():
	var bulletInst = bullet.instantiate()
	bulletInst.position = position
	bulletInst.position.x = position.x + 32 * (-1+2*direction)
	bulletInst.speed = speed
	if direction == Dir.LEFT:
		bulletInst.direction = Vector2.LEFT
	if direction == Dir.RIGHT:
		bulletInst.direction = Vector2.RIGHT
	get_parent().add_child(bulletInst)
	$AnimationPlayer.play('fire')
	$GPUParticles2D.emitting = true
