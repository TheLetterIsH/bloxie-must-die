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
var score: float = 0.0

var move_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true

var health: int = 3

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


func restart_doom_timer() -> void:
	doom_timer.start(doom_wait_time)


func destroy() -> void:
	self.queue_free()


func perform_effects(effect_type: String) -> void:
	if effect_type == "dash":
		dash_trail_particles.emitting = true


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
	update_health(health - 1)


func _on_hurt_box_area_2d_body_entered(other_body: Node2D) -> void:
	update_health(health - 1)


func _on_collectible_area_2d_area_entered(other_area: Area2D) -> void:
	update_score(score + 1)
	restart_doom_timer()


func get_time_alive() -> float:
	return time_alive


func get_score() -> int:
	return score
