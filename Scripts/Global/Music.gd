extends AudioStreamPlayer

const punk = preload("res://Audio/PerituneMaterial_CyberPunk_City.mp3")
const gg = preload("res://Audio/MusMus-BGM-143.mp3")

func change_music(mus):
	stream = mus
	play()
