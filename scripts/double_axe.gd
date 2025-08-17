extends Weapon
class_name DoubleAxe

const sword_slash_preload = preload("res://scenes/sword_slash.tscn")

@onready var double_axe_anim: AnimationPlayer = $DoubleAxeAnim

func _ready() -> void:
	super._ready()
	
func perform_attack():
	double_axe_anim.play("slash")

func spawn_slash():
	var slash_var = sword_slash_preload.instantiate()
	slash_var.global_position = owner_node.global_position
	slash_var.get_node("Sprite2D/AnimationPlayer").speed_scale = slash_var.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / attack_time
	slash_var.get_node("Sprite2D").flip_v = false if owner_node.get_global_mouse_position().x > owner_node.global_position.x else true
	slash_var.weapon_damage = damage
	slash_var.change_slash_cshape(40)
	slash_var.knockback_force = knockback_force
	slash_var.knockback_duration = knockback_duration
	owner_node.get_parent().add_child(slash_var)

func _on_double_axe_animation_finished(anim_name: StringName) -> void:
	pass
