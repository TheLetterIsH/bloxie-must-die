extends CanvasLayer

@onready var highest_time_label: RichTextLabel = %HighestTimeLabel
@onready var high_score_label: RichTextLabel = %HighScoreLabel


func _ready() -> void:
	highest_time_label.text = "[center]%s[/center]" % Utils.get_formatted_time(GameManager.highest_time)
	high_score_label.text = "[center]%s[/center]" % GameManager.high_score


func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/game arena/game_arena.tscn", {
		"speed": 3.5,
		"wait_time": 0.0,
		"color": Color("#262626"),
		"pattern": "squares"
	})


func _on_quit_button_pressed() -> void:
	get_tree().quit()
