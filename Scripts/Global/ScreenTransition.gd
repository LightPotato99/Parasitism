extends CanvasLayer

@onready var anim = $AnimationPlayer
var playing:bool = false

func restart_level():
	await get_tree().create_timer(0.05).timeout
	playing = true
	anim.play('RESET')
	await get_tree().create_timer(0.3).timeout
	anim.play("square_rotate_in")
	await anim.animation_finished
	get_tree().reload_current_scene() #only returns error when player is crushed, idk why
	anim.play("square_rotate_out")
	await anim.animation_finished
	playing = false
	
func change_level(warp_to):
	await get_tree().create_timer(0.05).timeout
	playing = true
	anim.play('RESET')
	anim.play("square_rotate_in")
	await anim.animation_finished
	get_tree().change_scene_to_file(warp_to)
	anim.play("square_rotate_out")
	await anim.animation_finished
	playing = false
