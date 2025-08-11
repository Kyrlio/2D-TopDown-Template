extends CharacterBody2D
class_name Enemy

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")

const FRICTION: float = 150.0

@export var health: float = 3.0
@export var speed: float = 35.0
@export var can_move: bool = true
@export var damage: float = 1.0

var taking_damage: bool = false
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
@export var knockback_force: float = 50.0
@export var knockback_duration: float = 0.12


func _ready() -> void:
	add_to_group("enemy")


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if player_node and can_move:
		var direction = (player_node.global_position - global_position).normalized()
		$Sprite2D.look_at(player_node.global_position)
		velocity = lerp(velocity, direction * speed, 8.5 * delta)
	
	move_and_slide()


func take_damage(weapon_damage: float):
	$Sprite2D/AnimationPlayer.play("take_damage")
	health -= weapon_damage
	
	if health <= 0.0:
		queue_free()
	
	taking_damage = true


func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, knockback_force, knockback_duration)
		body.take_damage(damage)
