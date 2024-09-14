extends Node


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func get_effects_container() -> Node2D:
	return get_tree().get_first_node_in_group("effects_container")
