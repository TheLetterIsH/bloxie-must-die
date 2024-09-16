extends Node


func get_formatted_time(seconds: int) -> String:
	var minutes := int(seconds / 60)
	var remaining_seconds := int(seconds % 60)
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2)
