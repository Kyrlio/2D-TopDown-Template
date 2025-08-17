extends Weapon
class_name Sword

@onready var sword_anim: AnimationPlayer = $SwordAnim

const sword_slash_preload = preload("res://scenes/sword_slash.tscn")

func _ready() -> void:
	super._ready()
	if sword_anim:
		sword_anim.animation_finished.connect(_on_sword_animation_finished)

func perform_attack():
	combo_count += 1
	can_attack = false
	attack_buffered = false
	
	if combo_count == 1:
		combo_window_timer = combo_window_duration
	
	var anim_name = get_attack_animation_name()
	
	sword_anim.speed_scale = sword_anim.get_animation(anim_name).length / attack_time
	sword_anim.play(anim_name)
	attack_started.emit(combo_count)
	
	#print("Sword: Combo hit: ", combo_count, " | Animation: ", anim_name)

func get_attack_animation_name() -> String:
	match combo_count:
		1: return "slash"
		2: return "slash_2"
		_: return "slash"

func reset_combo() -> void:
	#print("Sword: Reset combo, count was: ", combo_count)
	if combo_count == 1:
		sword_anim.speed_scale = sword_anim.get_animation("sword_return").length / return_time
		sword_anim.play("sword_return") 
	super.reset_combo()

func spawn_slash():
	var sword_slash_var = sword_slash_preload.instantiate()
	sword_slash_var.global_position = owner_node.global_position
	sword_slash_var.get_node("Sprite2D/AnimationPlayer").speed_scale = sword_slash_var.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / attack_time
	sword_slash_var.get_node("Sprite2D").flip_v = false if owner_node.get_global_mouse_position().x > owner_node.global_position.x else true
	sword_slash_var.weapon_damage = damage
	owner_node.get_parent().add_child(sword_slash_var)

func _global_spawn_slash():
	spawn_slash()

func _on_sword_animation_finished(anim_name: String) -> void:
	match anim_name:
		"slash":
			can_attack = true
			await owner_node.get_tree().create_timer(0.2).timeout
			if combo_count == 1:
				reset_combo()
				
		"slash_2":
			reset_combo()
			owner_node.get_tree().create_timer(0.15).timeout
			can_attack = true
		
		"sword_return":
			can_attack = true
	
	attack_finished.emit(combo_count)
