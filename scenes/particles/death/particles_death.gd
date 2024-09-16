extends GPUParticles2D


func _ready() -> void:
	self.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	self.queue_free()
