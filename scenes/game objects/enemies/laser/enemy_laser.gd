extends Area2D

@export var color: Color
@export var beam_scene: PackedScene
@export var death_particles_scene: PackedScene

var player: Player

var target_found: bool

@onready var sprite: Sprite2D = $Sprite2D
@onready var indicator_sprite: Sprite2D = $IndicatorSprite2D


func _ready() -> void:
	player = ObjectManager.get_player() as Player
	
	perform_effects("spawn")
	
	shoot_at_player()


func _process(delta: float) -> void:
	if player == null:
		return
	
	if not target_found:
		look_at(player.global_position)


func shoot_at_player() -> void:
	await get_tree().create_timer(1.0).timeout
	
	if player == null:
		return
	
	var target_position := (player.global_position - self.global_position).normalized() * 800
	target_found = true
	
	var visiblity_bool := false
	var tween := self.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	for i in range(5):
		tween.tween_property(indicator_sprite, "visible", visiblity_bool, 0.08)
		visiblity_bool = !visiblity_bool
	
	await tween.finished
	
	var beam_instance := beam_scene.instantiate()
	beam_instance.global_position = self.global_position
	ObjectManager.get_projectile_container().add_child(beam_instance)
	beam_instance.line.set_point_position(1, target_position)
	beam_instance.ray_cast.target_position = target_position
	beam_instance.ray_cast.enabled = true
	beam_instance.modulate = color
	
	perform_effects("shoot")
	
	await get_tree().create_timer(0.15).timeout
	
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
		SoundManager.play_sound_with_pitch(ResourceHolder.sound_shoot_1, randf_range(0.8, 1.2), "Sound")
	elif effect_type == "death":
		var death_particles_instance := death_particles_scene.instantiate()
		death_particles_instance.global_position = self.global_position
		ObjectManager.get_effects_container().add_child(death_particles_instance)
		death_particles_instance.modulate = color
