extends Camera2D

@export var target: Node = null

#dynamic movement
@export_category("Border Limits")
@export var leftLimit: int = -10000000
@export var topLimit: int = -10000000
@export var rightLimit: int = -10000000
@export var bottomLimit: int = -10000000
var camSpeed: float = 0.1
var xy:Vector2 = Vector2.ZERO

#screen shake
@onready var rand = RandomNumberGenerator.new()
var shakeIntensity:float = 0
var shakeDecayRate:float = 0

func _ready():
	if is_instance_valid(target):
		position = target.position
	else:
		target = self
	
	for lim in range(4):
		var limArray = [leftLimit, topLimit, rightLimit, bottomLimit]
		set_limit(lim, limArray[lim])

func _process(delta):
	if is_instance_valid(target):
		xy = target.position
		position = lerp(position, target.position, camSpeed)
	else:
		position = lerp(position, xy, camSpeed)
		
	shakeIntensity = lerp(shakeIntensity,0.0,shakeDecayRate * delta)
	offset = Vector2(
		rand.randf_range(-shakeIntensity,shakeIntensity),
		rand.randf_range(-shakeIntensity,shakeIntensity)
	)
	
func shake_screen(decay,intensity):
	shakeDecayRate = decay
	shakeIntensity = intensity
