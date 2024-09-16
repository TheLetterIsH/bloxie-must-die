extends Area2D

@export var color: Color
@export var death_particles_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	perform_effects("spawn")


func destroy() -> void:
	(ObjectManager.get_director() as Director).call_deferred("spawn_point")
	
	perform_effects("death")
	
	self.queue_free()


func perform_effects(effect_type: String) -> void:
	if effect_type == "spawn":
		var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.1).from(Vector2.ZERO)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).from(Vector2(1.5, 1.5))
	elif effect_type == "death":
		var death_particles_instance := death_particles_scene.instantiate()
		death_particles_instance.global_position = self.global_position
		ObjectManager.get_effects_container().add_child(death_particles_instance)
		death_particles_instance.modulate = color


func _on_area_entered(area: Area2D) -> void:
	destroy()
