extends CharacterBody2D
class_name Player

const MAX_SPEED: int = 65
const ACCELERATION: float = 16.5
const FRICTION: float = 8.5

var current_look_dir = "right"

# --- ANIMATIONS ---
@onready var flip_anim: AnimationPlayer = $Sprite2D/flip_anim
@onready var sword: Sprite2D = $Sprite2D/Sword
@onready var sword_anim: AnimationPlayer = $Sprite2D/Sword/SwordAnim
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health: float = 3.0
var is_hurt: bool = false

# --- ATTACKS ---
var can_slash: bool = true
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		if not is_hurt:
			move(delta)
	# --- ATTACK ---
	if Input.is_action_pressed("attack") and can_slash:
		sword_anim.speed_scale = sword_anim.get_animation("slash").length / slash_time
		sword_anim.play("slash")
		can_slash = false
	
	update_look() 
	move_and_slide()


func move(delta: float):
	# --- MOVEMENTS ---
	var input = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if input:
		animation_player.play("walk")
		#$Sprite2D.flip_h = true if input.x < 0 else false
		animation_player.speed_scale = (velocity/MAX_SPEED).distance_to(Vector2.ZERO) + 0.1
	else:
		animation_player.speed_scale = 0.75
		if not is_hurt:
			animation_player.stop()
	
	var velocity_weight_x: float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x)
	
	var velocity_weight_y: float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y)


func update_look():
	if current_look_dir == "right" and get_global_mouse_position().x < global_position.x:
		flip_anim.play("look_left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x > global_position.x:
		flip_anim.play("look_right")
		current_look_dir = "right"


const sword_slash_preload = preload("res://scenes/sword_slash.tscn")
func spawn_slash():
	var sword_slash_var = sword_slash_preload.instantiate()
	sword_slash_var.global_position = global_position
	sword_slash_var.get_node("Sprite2D/AnimationPlayer").speed_scale = sword_slash_var.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / slash_time
	sword_slash_var.get_node("Sprite2D").flip_v = false if get_global_mouse_position().x > global_position.x else true
	sword_slash_var.weapon_damage = weapon_damage
	get_parent().add_child(sword_slash_var)


func _on_sword_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		sword_anim.speed_scale = sword_anim.get_animation("sword_return").length / sword_return_time
		sword_anim.play("sword_return")
	else:
		can_slash = true


func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration


func take_damage(damage: float):
	if not is_hurt:
		health -= damage
		print("life : " + str(health))
		
		if health <= 0.0:
			queue_free()
		
		is_hurt = true
		animation_player.play("hurt")
	else:
		return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		is_hurt = false
