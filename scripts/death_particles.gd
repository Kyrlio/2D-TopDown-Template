extends Node2D

func death_particles():
	$GPUParticles2D.emitting = true

func trail_death_particles():
	$GPUParticles2D2.emitting = true
	await get_tree().create_timer(0.2).timeout
	$GPUParticles2D2.emitting = false

func _on_gpu_particles_2d_finished() -> void:
	queue_free()
