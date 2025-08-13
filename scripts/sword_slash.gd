extends Node2D
class_name WeaponSlash

var weapon_damage: float = 1.0
@export var knockback_force: float = 50.0
@export var knockback_duration: float = 0.12

func _ready() -> void:
	look_at(get_global_mouse_position())
	$Sprite2D/AnimationPlayer.play("slash")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body is Enemy:
		body.take_damage(weapon_damage)
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, knockback_force, knockback_duration)

func get_area_2d() -> Area2D:
	return $Area2D
