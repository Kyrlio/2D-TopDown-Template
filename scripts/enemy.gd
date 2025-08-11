extends CharacterBody2D

var health: float = 3.0

func _ready() -> void:
	add_to_group("enemy")

func take_damage(weapon_damage: float):
	$Sprite2D/AnimationPlayer.play("take_damage")
	health -= weapon_damage
	
	if health <= 0.0:
		queue_free()
