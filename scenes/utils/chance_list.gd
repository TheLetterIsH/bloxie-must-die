extends Node
class_name ChanceList

var chance_list: Array = []
var chance_definitions: Array = []


func _init(definitions: Array) -> void:
	chance_definitions = definitions


func generate_chance_list() -> void:
	for chance_definition in chance_definitions:
		for i in range(chance_definition[1]):
			chance_list.append(chance_definition[0]);
	
	chance_list.shuffle()


func get_random_element():
	if len(chance_list) == 0:
		generate_chance_list()
	
	return chance_list.pop_back()
