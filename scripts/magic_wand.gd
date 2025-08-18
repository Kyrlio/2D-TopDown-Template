extends Weapon
class_name MagicWand

const PROJECTILE = preload("res://scenes/projectile.tscn")

const IS_PLAYER = true

@onready var shoot_pos: Marker2D = $Sprite2D/ShootPos
@onready var magic_wand_anim: AnimationPlayer = $MagicWandAnim

var time_between_shot: float = 0.25

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot

func perform_attack():
	if can_attack:
		can_attack = false
		$ShootTimer.start()
		magic_wand_anim.play("slash")
		combo_count += 1

func reset_combo():
	if combo_count == 1:
		magic_wand_anim.speed_scale = magic_wand_anim.get_animation("return").length / return_time
		magic_wand_anim.play("return") 
	super.reset_combo()

func _shoot():
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = shoot_pos.global_position
	
	# Calculer la direction vers la souris
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - shoot_pos.global_position).normalized()
	new_projectile.global_rotation = direction.angle()
	
	owner_node.get_parent().add_child(new_projectile)

func _on_shoot_timer_timeout() -> void:
	can_attack = true

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	await owner_node.get_tree().create_timer(0.2).timeout
	reset_combo()
