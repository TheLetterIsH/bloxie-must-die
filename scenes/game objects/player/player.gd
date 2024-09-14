extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var speed: float = 225.0
@export var acceleration: float = 0.25
@export var friction: float = 0.35
@export var dash_speed: float = 550.0
@export var dash_duration_wait_time: float = 0.1
@export var dash_cooldown_wait_time: float = 1.0

var move_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true

@onready var dash_duration_timer: Timer = %DashDurationTimer
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var dash_trail_particles: GPUParticles2D = $DashTrailParticles


func _ready() -> void:
	pass


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
	
	perform_effects("dash")


func perform_effects(effect_type: String) -> void:
	if effect_type == "dash":
		dash_trail_particles.emitting = true


func _on_dash_duration_timer_timeout() -> void:
	dash_cooldown_timer.start(dash_cooldown_wait_time)
	
	is_dashing = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
