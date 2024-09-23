extends Node

signal player_health_updated
signal player_score_updated
signal player_dashed
signal player_death

func fire_player_health_updated() -> void:
	player_health_updated.emit()


func fire_player_score_updated() -> void:
	player_score_updated.emit()


func fire_player_dashed() -> void:
	player_dashed.emit()


func fire_player_death() -> void:
	player_death.emit()


# for reference:
	# checks
	# events
	# timers
	# variables
	# effects call
