extends Camera2D

@onready var shaker_component: ShakerComponent2D = $ShakerComponent2D


func _ready() -> void:
	GameEvents.player_dashed.connect(on_player_dashed)
	GameEvents.player_health_updated.connect(on_player_health_updated)


func on_player_dashed() -> void:
	shaker_component.play_shake()


func on_player_health_updated() -> void:
	shaker_component.play_shake()
