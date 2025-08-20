extends Node2D
class_name WeaponSlash

var weapon_damage: float = 1.0
@export var knockback_force: float = 50.0:
	set(value):
		knockback_force = value
	get:
		return knockback_force
@export var knockback_duration: float = 0.12:
	set(value):
		knockback_duration = value
	get:
		return knockback_duration

@onready var cshape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	look_at(get_global_mouse_position())
	$Sprite2D/AnimationPlayer.play("slash")
	# Vérification que cshape est bien initialisé
	if not cshape:
		print("Warning: cshape is null!")


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

func change_slash_cshape(x: int, y: int) -> void:
	var collision_shape = get_node("Area2D/CollisionShape2D")
	if collision_shape:
		var rect_shape = RectangleShape2D.new()
		rect_shape.size = Vector2(x, y)
		collision_shape.shape = rect_shape
	else:
		print("CollisionShape2D not found!")
