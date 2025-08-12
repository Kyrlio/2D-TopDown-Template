extends Node2D

func death_particles():
	$GPUParticles2D.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
