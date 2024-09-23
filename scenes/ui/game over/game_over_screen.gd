extends CanvasLayer

@export var insults: Array[String]

@onready var insult_label: RichTextLabel = %InsultLabel
@onready var time_label: RichTextLabel = %TimeLabel
@onready var score_label: RichTextLabel = %ScoreLabel
@onready var highest_time_label: RichTextLabel = %HighestTimeLabel
@onready var high_score_label: RichTextLabel = %HighScoreLabel
@onready var retry_button: BetterButton = %RetryButton
@onready var menu_button: BetterButton = %MenuButton


func _ready() -> void:
	insult_label.text = "[wave amp=20.0 freq=5.0][center]%s[/center][/wave]" % insults.pick_random()
	time_label.text = "[center]%s[/center]" % Utils.get_formatted_time(GameManager.time)
	score_label.text = "[center]%s[/center]" % GameManager.score
	highest_time_label.text = "[center]%s[/center]" % Utils.get_formatted_time(GameManager.highest_time)
	high_score_label.text = "[center]%s[/center]" % GameManager.high_score


func _on_retry_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/game arena/game_arena.tscn", {
		"speed": 3.5,
		"wait_time": 0.0,
		"color": Color("#262626"),
		"pattern": "squares"
	})


func _on_menu_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/ui/main menu/main_menu_screen.tscn", {
		"speed": 3.5,
		"wait_time": 0.0,
		"color": Color("#262626"),
		"pattern": "squares"
	})
