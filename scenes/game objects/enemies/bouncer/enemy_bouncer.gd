extends CharacterBody2D

@export var speed: float = 160
@export var collision_count: int = 0
@export var max_collision_count: int = 4

@export var death_particles_scene: PackedScene

var color: Color

@onready var sprite: Sprite2D = %OuterSprite2D
@onready var inner_sprite: Sprite2D = $InnerSprite2D


func _ready() -> void:
	var move_direction = get_random_direction_vector()
	velocity = move_direction * speed
	max_collision_count = randi_range(4, 6)
	perform_effects("spawn")


func _process(delta: float) -> void:
	rotation_degrees += 180 * delta
	
	if collision_count >= max_collision_count:
		destroy()


func _physics_process(delta) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("hit")
		velocity = velocity.bounce(collision.get_normal())
		collision_count += 1
		
		#change_color()
		perform_effects("bounce")


func destroy() -> void:
	perform_effects("death")
	
	self.queue_free()


func perform_effects(effect_type: String) -> void:
	if effect_type == "spawn":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.05)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	elif effect_type == "bounce":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.05)
		tween.parallel().tween_property(inner_sprite, "scale", Vector2(1.5, 1.5), 0.05)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.05)
		tween.parallel().tween_property(inner_sprite, "scale", Vector2(1.0, 1.0), 0.05)
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_shoot_2, randf_range(1.5, 1.9), "Sound")
	elif effect_type == "death":
		var death_particles_instance := death_particles_scene.instantiate()
		death_particles_instance.global_position = self.global_position
		ObjectManager.get_effects_container().add_child(death_particles_instance)
		death_particles_instance.modulate = color


func get_random_direction_vector() -> Vector2:
	var random_x = randf_range(-1, 1)
	var random_y = randf_range(-1, 1)
	var random_vector = Vector2(random_x, random_y)
	return random_vector.normalized()


func _on_hit_box_area_2d_area_entered(area: Area2D) -> void:
	destroy()
