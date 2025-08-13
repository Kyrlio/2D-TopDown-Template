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
@onready var run_particles: GPUParticles2D = $RunParticles

@export var health: float = 3.0
var is_hurt: bool = false

# --- MOVEMENTS ---
var input: Vector2 = Vector2.ZERO
var active: bool = true

# Dashing
var is_dashing: bool = false
var dash_start_position: Vector2 = Vector2.ZERO
var dash_direction: Vector2 = Vector2.ZERO
var dash_timer : float = 0.0
@export var dash_speed: float = 200.0
@export var dash_max_distance: float = 70.0
@export var dash_curve: Curve
@export var dash_cooldown: float = 1

# --- ATTACKS & COMBOS---
var can_slash: bool = true
@export var slash_time: float = 0.3
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0

var combo_count: int = 0
var max_combo: int = 2
var combo_window_timer: float = 0.0
@export var combo_window_duration: float = 0.8 # Temps pour enchainer le prochain coup
var attack_buffered: bool = false # Pour gérer les inputs en buffer pendant l'animation

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		if not is_hurt and not is_dashing:
			move(delta)
	
	# --- ATTACK SYSTEM ---
	handle_attack_input()
	
	# --- DASH ---
	if Input.is_action_just_pressed("dash") and not is_hurt and input and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position
		dash_direction = input
		dash_timer = dash_cooldown
		animation_player.play("dash")
		var dash_duration = dash_max_distance / dash_speed
		var animation_length = animation_player.get_animation("dash").length
		animation_player.speed_scale =  animation_length / dash_duration
		#print("dash duration: ", dash_duration, " | animation length: ", animation_length, " | animation speed scale: ", animation_player.speed_scale)
	
	update_look()
	dash(delta)
	move_and_slide()


func dash(delta):
	# Perform dash
	if is_dashing:
		can_slash = false
		var current_distance = position.distance_to(dash_start_position)
		#print("dash? ", is_dashing, " | pos: ", global_position, " | start: ", dash_start_position, " | dist: ", current_distance)
		if current_distance >= dash_max_distance or is_on_wall():
			not_dashing()
		else:
			velocity = dash_direction * dash_speed 
	
	# Reduces dash timer
	if dash_timer > 0:
		dash_timer -= delta

func not_dashing():
	if not is_dashing:
		return
	else:
		can_slash = true
		is_dashing = false

func move(delta: float):
	# --- MOVEMENTS ---
	input = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if input:
		run_particles.emitting = true
		animation_player.play("walk")
		#$Sprite2D.flip_h = true if input.x < 0 else false
		animation_player.speed_scale = (velocity/MAX_SPEED).distance_to(Vector2.ZERO) + 0.1
	else:
		run_particles.emitting = false
		animation_player.speed_scale = 0.75
		if not is_hurt:
			animation_player.play("idle")
			#animation_player.stop()
	
	var velocity_weight_x: float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x)
	
	var velocity_weight_y: float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y)


func update_look():
	#print(current_look_dir, " | ", get_global_mouse_position().x, " | ", global_position.x)
	if current_look_dir == "right" and get_global_mouse_position().x < global_position.x:
		flip_anim.play("look_left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x > global_position.x:
		flip_anim.play("look_right")
		current_look_dir = "right"
	
	#print(get_global_mouse_position().y, " | ", global_position.y - 10)
	
	if get_global_mouse_position().y > (global_position.y - 20):
		$Sprite2D/Sword.show_behind_parent = false
		$Sprite2D.frame = 0
	else:
		$Sprite2D/Sword.show_behind_parent = true
		$Sprite2D.frame = 1


func handle_attack_input():
	if Input.is_action_pressed("attack"):
		if can_slash:
			perform_attack()
		else:
			attack_buffered = true


func perform_attack():
	combo_count += 1
	can_slash = false
	attack_buffered = false
	
	if combo_count == 1:
		combo_window_timer = combo_window_duration
	
	var anim_name = get_slash_animation_name()
	
	sword_anim.speed_scale = sword_anim.get_animation(anim_name).length / slash_time
	sword_anim.play(anim_name)
	
	print("Combo hit: ", combo_count, " | Animation: ", anim_name)


func get_slash_animation_name() -> String:
	match combo_count:
		1: return "slash"
		2: return "slash_2"
		_: return "slash"


func reset_combo():
	print(combo_count)
	if combo_count == 1:
		sword_anim.speed_scale = sword_anim.get_animation("sword_return").length / sword_return_time
		sword_anim.play("sword_return") 
	combo_count = 0
	attack_buffered = false
	
	


const sword_slash_preload = preload("res://scenes/sword_slash.tscn")
func spawn_slash():
	var sword_slash_var = sword_slash_preload.instantiate()
	sword_slash_var.global_position = global_position
	sword_slash_var.get_node("Sprite2D/AnimationPlayer").speed_scale = sword_slash_var.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / slash_time
	sword_slash_var.get_node("Sprite2D").flip_v = false if get_global_mouse_position().x > global_position.x else true
	sword_slash_var.weapon_damage = weapon_damage
	get_parent().add_child(sword_slash_var)


func _on_sword_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"slash":
			can_slash = true
			await get_tree().create_timer(0.2).timeout
			if combo_count == 1:
				reset_combo()
		
		"slash_2":
			reset_combo()
			can_slash = true
		
		"sword_return":
			can_slash = true


func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration


func take_damage(damage: float):
	if not is_hurt:
		if is_dashing:
			not_dashing()
		
		reset_combo()
		can_slash = true
		
		health -= damage
		print("life : " + str(health))
		
		if health <= 0.0:
			queue_free()
		
		is_hurt = true
		
		# Play correct animation
		if current_look_dir == "right":
			animation_player.play("hurt_right")
		elif current_look_dir == "left":
			animation_player.play("hurt_left")
	else:
		return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"hurt_right": is_hurt = false
		"hurt_left": is_hurt = false
		"dash": not_dashing()
		_: return
