extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 120.0
@export var damage: float = 2.0
@export var knockback_force: float = 30.0
@export var knockback_duration: float = 0.12

func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation) * speed * delta


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "remove":
		queue_free()


func _on_distance_timeout_timeout() -> void:
	animation_player.play("remove")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage)
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, knockback_force, knockback_duration)
		animation_player.play("remove")
