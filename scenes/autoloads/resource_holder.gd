extends Node

var sound_dash: AudioStream = preload("res://resources/sounds/172206__leszek_szary__teleport.wav")
var sound_shoot_1: AudioStream = preload("res://resources/sounds/344312__musiclegends__laser-shoot7.wav")
var sound_point: AudioStream = preload("res://resources/sounds/328118__greenvwbeetle__pop-7.wav")
var sound_hurt: AudioStream = preload("res://resources/sounds/171530__leszek_szary__change-menu.wav")
var sound_projectile_destroyed: AudioStream = preload("res://resources/sounds/171521__leszek_szary__button.wav")

func _ready() -> void:
	SoundManager.set_sound_volume(0.5) # TODO in settings manager
