extends Node

var score: int
var time: float
var high_score: int
var highest_time: float


func _ready() -> void:
	high_score = SaveSystem.get_var("high_score", 0)
	highest_time = SaveSystem.get_var("highest_time", 0.0)


func set_score(new_score: int) -> void:
	score = new_score
	
	if score > high_score:
		high_score = score
		SaveSystem.set_var("high_score", high_score)
		SaveSystem.save()


func set_time(new_time: int) -> void:
	time = new_time
	
	if time > highest_time:
		highest_time = time
		SaveSystem.set_var("highest_time", highest_time)
		SaveSystem.save()
