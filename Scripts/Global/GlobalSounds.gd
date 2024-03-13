extends Node

const death = preload("res://Audio/SFX/Death.wav")
const jump = preload("res://Audio/SFX/Jump.ogg")
const cast = preload("res://Audio/SFX/Cast.wav")
const castOut = preload("res://Audio/SFX/CastOut.wav")
const bulletDestroy = preload("res://Audio/SFX/BulletDestroy.wav")
const dJump = preload("res://Audio/SFX/DJump.wav")
const land = preload("res://Audio/SFX/Land.wav")
const crusherLand = preload("res://Audio/SFX/CrusherLand.wav")
const keycardGet = preload("res://Audio/SFX/KeycardGet.wav")
const redKeycardPending = preload("res://Audio/SFX/RedKeycardPending.wav")

@onready var audioPlayers: Node = $AudioPlayerList

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

func play_sound(sound) -> void:
	for audioStreamPlayers in audioPlayers.get_children():
		if not audioStreamPlayers.playing:
			audioStreamPlayers.stream = sound
			audioStreamPlayers.play()
			break

func stop_sound(sound) -> void:
	for audioStreamPlayers in audioPlayers.get_children():
		if audioStreamPlayers.get_stream() == sound:
			audioStreamPlayers.stop()
	
