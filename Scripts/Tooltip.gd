extends Node2D

@export var img:Texture2D
@export_multiline var txt : String
@export var detectRadius:float = 250
@export var showTime:bool = false
@export var showDeath:bool = false

func _ready():
	$ToolImg.texture = img
	if txt.count("\n") == 0:
		$Label.label_settings.font_size = 16
	else:
		$Label.label_settings.font_size = 12
	$Area2D/CollisionShape2D.shape.radius = detectRadius
	
	if showTime:
		txt = GLOBAL_GAME.timeText
		Music.change_music(Music.gg)
	if showDeath:
		txt = str(GLOBAL_GAME.deaths)
	$Label.text = txt

func _on_area_2d_body_entered(_body):
	$AnimationPlayer.play('open')
	
func _on_area_2d_body_exited(_body):
	$AnimationPlayer.play('close')
