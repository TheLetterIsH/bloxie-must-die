extends Node2D

@export var color: Color
@export var projectile_scene: PackedScene
@export var death_particles_scene: PackedScene

var player: Player

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	player = ObjectManager.get_player() as Player
	
	perform_effects("spawn")
	
	shoot_at_player()


func shoot_at_player() -> void:
	await get_tree().create_timer(1.0).timeout
	
	if player == null:
		return
	
	var projectile_instance := projectile_scene.instantiate()
	projectile_instance.global_position = self.global_position
	ObjectManager.get_projectile_container().add_child(projectile_instance)
	projectile_instance.move_direction = (player.global_position - self.global_position).normalized()
	projectile_instance.modulate = color
	
	perform_effects("shoot")
	
	await get_tree().create_timer(0.1).timeout
	
	destroy()


func destroy() -> void:
	perform_effects("death")
	
	self.queue_free()


func perform_effects(effect_type: String) -> void:
	if effect_type == "spawn":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.25, 1.25), 0.05)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.05)
	elif effect_type == "shoot":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.05)
		tween.tween_property(sprite, "scale", Vector2(0.5, 0.5), 0.05)
	elif effect_type == "death":
		var death_particles_instance := death_particles_scene.instantiate()
		death_particles_instance.global_position = self.global_position
		ObjectManager.get_effects_container().add_child(death_particles_instance)
		death_particles_instance.modulate = color
