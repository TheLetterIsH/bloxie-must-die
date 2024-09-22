extends Control

@export var heart_texture_rect_scene: PackedScene

var player: Player

@onready var time_alive_label: RichTextLabel = %TimeAliveLabel
@onready var score_label: RichTextLabel = %ScoreLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var dash_bar: TextureProgressBar = %DashBar
@onready var doom_bar: TextureProgressBar = %DoomBar
@onready var fps_label: RichTextLabel = %FPSLabel
@onready var health_flow_container: FlowContainer = %HealthFlowContainer


func _ready() -> void:
	GameEvents.player_health_updated.connect(update_health_hearts)
	GameEvents.player_score_updated.connect(update_score_label)
	
	player = ObjectManager.get_player() as Player
	
	update_health_hearts()
	update_score_label()


func _process(delta: float) -> void:
	update_time_alive_label()
	update_dash_bar()
	update_doom_bar()
	update_fps_label()


func update_time_alive_label() -> void:
	if player == null:
		return
		
	time_alive_label.text = Utils.get_formatted_time(player.get_time_alive())


func update_score_label() -> void:
	if player == null:
		return
	
	score_label.text = str(player.get_score())
	
	#perform_effects("score")


func update_health_hearts() -> void:
	if player == null:
		return
	
	var health_hearts := health_flow_container.get_children()
	
	for health_heart in health_hearts:
		health_heart.queue_free()
	
	for i in range(player.health):
		var heart_texture_rect_instance := heart_texture_rect_scene.instantiate()
		health_flow_container.add_child(heart_texture_rect_instance)


func update_dash_bar() -> void:
	if player == null:
		return
	
	dash_bar.value = player.dash_cooldown_wait_time - player.dash_cooldown_timer.time_left


func update_doom_bar() -> void:
	if player == null:
		return
	
	doom_bar.value = player.doom_timer.time_left


func update_fps_label() -> void:
	fps_label.text = "fps: " + str(Engine.get_frames_per_second())


#func perform_effects(effect_type: String) -> void:
	#time_alive_label.pivot_offset = time_alive_label.size / 2
	#score_label.pivot_offset = score_label.size / 2
	#health_bar.pivot_offset = health_bar.size / 2
	#dash_bar.pivot_offset = dash_bar.size / 2
	#
	#if effect_type == "score":
		#var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		#tween.tween_property(score_label, "rotation", 5, 2).from(0.0)
		#tween.parallel().tween_property(score_label, "rotation", -5, 2).from(5)
		#tween.parallel().tween_property(score_label, "rotation", 0.0, 2)
