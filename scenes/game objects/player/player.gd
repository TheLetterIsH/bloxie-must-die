extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var speed: float = 225.0
@export var acceleration: float = 0.25
@export var friction: float = 0.35
@export var dash_speed: float = 550.0
@export var dash_duration_wait_time: float = 0.1
@export var dash_cooldown_wait_time: float = 1.0
@export var doom_wait_time: float = 12.0

@export_group("Health")
@export var max_health: int = 3

var time_alive: float = 0.0
var score: int = 0

var move_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true

var health: int = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_duration_timer: Timer = %DashDurationTimer
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var doom_timer: Timer = %DoomTimer
@onready var dash_trail_particles: GPUParticles2D = $DashTrailParticles
@onready var hurt_box_area_2d: Area2D = %HurtBoxArea2D
@onready var hurt_box_collision_shape_2d: CollisionShape2D = %HurtBoxCollisionShape2D
@onready var collectible_area_2d: Area2D = %CollectibleArea2D


func _ready() -> void:
	update_health(max_health)


func _process(delta: float) -> void:
	time_alive += delta


func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	move_and_slide()


func handle_input() -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if can_dash and Input.is_action_just_pressed("dash"):
		dash()


func handle_movement() -> void:
	if is_dashing:
		return
	
	if move_direction.length() > 0:
		velocity = velocity.lerp(move_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)


func dash() -> void:
	if move_direction == Vector2.ZERO:
		return
	
	GameEvents.fire_player_dashed()
	
	dash_duration_timer.start(dash_duration_wait_time)
	
	can_dash = false
	is_dashing = true
	
	velocity = move_direction * dash_speed
	
	hurt_box_collision_shape_2d.disabled = true
	
	perform_effects("dash")


func update_health(new_health: int) -> void:
	health = new_health
	
	GameEvents.fire_player_health_updated()
	
	if health <= 0:
		destroy()


func update_score(new_score: int) -> void:
	score = new_score
	
	GameEvents.fire_player_score_updated()
	
	if score % 50 == 0 and health < 6:
		update_health(health + 1)
		perform_effects("health")


func take_damage() -> void:
	update_health(health - 1)
	
	perform_effects("hurt")


func restart_doom_timer() -> void:
	doom_timer.start(doom_wait_time)


func destroy() -> void:
	self.queue_free()


func perform_effects(effect_type: String) -> void:
	if effect_type == "dash":
		dash_trail_particles.emitting = true
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_dash, randf_range(1.2, 1.6), "Sound")
	elif effect_type == "hurt":
		sprite.material.set("shader_parameter/flash_value", 1.0)
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite.material, "shader_parameter/squash_direction", Vector2(0.0, 1.0), 0.1)
		tween.tween_property(sprite.material, "shader_parameter/squash_direction", Vector2.ZERO, 0.1)
		tween.finished.connect(func():
			self.sprite.material.set("shader_parameter/flash_value", 0.0)
		)
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_hurt, randf_range(0.8, 1.2), "Sound")
	elif effect_type == "score":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.05)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.05).from_current()
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_point, randf_range(1.8, 2.2), "Sound")
	elif effect_type == "health":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.05)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.05).from_current()
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_health, randf_range(0.8, 1.2), "Sound")


func _on_dash_duration_timer_timeout() -> void:
	dash_cooldown_timer.start(dash_cooldown_wait_time)
	
	is_dashing = false
	
	await get_tree().create_timer(0.1).timeout
	
	hurt_box_collision_shape_2d.disabled = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true


func _on_doom_timer_timeout() -> void:
	destroy()


func _on_hurt_box_area_2d_area_entered(other_area: Area2D) -> void:
	take_damage()


func _on_hurt_box_area_2d_body_entered(other_body: Node2D) -> void:
	take_damage()


func _on_collectible_area_2d_area_entered(other_area: Area2D) -> void:
	update_score(score + 1)
	
	perform_effects("score")
	
	restart_doom_timer()


func get_time_alive() -> float:
	return time_alive


func get_score() -> int:
	return score
