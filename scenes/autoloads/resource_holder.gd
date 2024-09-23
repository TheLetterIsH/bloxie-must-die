extends Node

var sound_dash: AudioStream = preload("res://resources/sounds/172206__leszek_szary__teleport.wav")
var sound_shoot_1: AudioStream = preload("res://resources/sounds/344312__musiclegends__laser-shoot7.wav")
var sound_shoot_2: AudioStream = preload("res://resources/sounds/146725__leszek_szary__laser.wav")
var sound_point: AudioStream = preload("res://resources/sounds/328118__greenvwbeetle__pop-7.wav")
var sound_hurt: AudioStream = preload("res://resources/sounds/171530__leszek_szary__change-menu.wav")
var sound_health: AudioStream = preload("res://resources/sounds/146727__leszek_szary__energy.wav")
var sound_button_hover: AudioStream = preload("res://resources/sounds/328118__greenvwbeetle__pop-7.wav")
var sound_death: AudioStream = preload("res://resources/sounds/171530__leszek_szary__change-menu.wav")

func _ready() -> void:
	SoundManager.set_sound_volume(0.5) # TODO in settings manage
