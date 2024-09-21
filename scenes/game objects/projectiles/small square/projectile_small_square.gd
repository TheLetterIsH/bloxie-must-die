extends Area2D

@export var death_particles_scene: PackedScene

var move_direction: Vector2 = Vector2.ZERO
var speed: float = 140.0
var time: float = 0
var amplitude: float = 0.35
var frequency: float = 10.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	time += delta
	
	rotation_degrees = lerp_angle(rotation_degrees, rotation_degrees + 1, 2.0)
	
	var position_increment := move_direction * speed * delta
	var wave_offset := cos(frequency * time) * amplitude
	position += position_increment + Vector2(move_direction.y, -move_direction.x) * wave_offset


func destroy() -> void:
	perform_effects()
	
	self.queue_free()


func perform_effects() -> void:
	var death_particles_instance := death_particles_scene.instantiate()
	death_particles_instance.global_position = self.global_position
	ObjectManager.get_effects_container().add_child(death_particles_instance)
	death_particles_instance.modulate = self.modulate


func _on_area_entered(other_area: Area2D) -> void:
	destroy()


func _on_body_entered(other_body: Node2D) -> void:
	destroy()
