extends CharacterBody2D
class_name Enemy

const DEATH_PARTICLES = preload("res://scenes/death_particles.tscn")
const FRICTION: float = 150.0

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")

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
	
	if player_node and can_move and not taking_damage:
		var direction = (player_node.global_position - global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)
		$Sprite2D/AnimationPlayer.play("walk")
	
	move_and_slide()


func take_damage(weapon_damage: float):
	if not taking_damage:
		$Sprite2D/AnimationPlayer.play("take_damage")
		health -= weapon_damage
		
		if health <= 0.0:
			var death_scene = DEATH_PARTICLES.instantiate()
			add_sibling(death_scene)
			death_scene.global_position = global_position
			death_scene.death_particles()
			death()
		
		taking_damage = true
	else:
		return


func change_damage_bool():
	taking_damage = false if taking_damage == true else true


func death():
	queue_free()


func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, knockback_force, knockback_duration)
		body.take_damage(damage)
