extends Node


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func get_enemy_container() -> Node2D:
	return get_tree().get_first_node_in_group("enemy_container")


func get_projectile_container() -> Node2D:
	return get_tree().get_first_node_in_group("projectile_container")


func get_collectible_container() -> Node2D:
	return get_tree().get_first_node_in_group("collectible_container")


func get_effects_container() -> Node2D:
	return get_tree().get_first_node_in_group("effects_container")


func get_director() -> Director:
	return get_tree().get_first_node_in_group("director")
