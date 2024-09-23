extends Node2D

@export var mobile_controls_canvas_layer: PackedScene


func _ready() -> void:
	if OS.get_name() == "Android":
		self.add_child(mobile_controls_canvas_layer.instantiate())
	
	GameEvents.player_death.connect(on_player_death)


func on_player_death() -> void:
	GameManager.set_score(ObjectManager.get_player().score)
	GameManager.set_time(ObjectManager.get_player().time_alive)
	
	SceneManager.change_scene("res://scenes/ui/game over/game_over_screen.tscn", {
		"speed": 3.5,
		"wait_time": 0.0,
		"color": Color("#262626"),
		"pattern": "squares"
	})
