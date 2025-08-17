extends Node
class_name Weapon

# Signaux pour communiquer avec le WeaponManager
signal attack_started(combo_count: int)
signal attack_finished(combo_count: int)
signal combo_reset()

@export var damage: float = 1.0
@export var attack_time: float = 0.3
@export var return_time: float = 0.5
@export var combo_window_duration: float = 0.8 # Temps pour enchainer le prochain coup
@export var max_combo: int = 2

# Variables internes
var combo_count: int = 0:
	set(value):
		combo_count = value
	get:
		return combo_count
var combo_window_timer: float = 0.0
var attack_buffered: bool = false:
	set(value):
		attack_buffered = value
	get:
		return attack_buffered
var can_attack: bool = true:
	set(value):
		can_attack = value
	get:
		return can_attack

# Réf
var owner_node: CharacterBody2D
var animation_player: AnimationPlayer

func _ready() -> void:
	if get_parent().has_node("AnimationPlayer"):
		animation_player = get_node("AnimationPlayer")
	else:
		null

func initialize(player: CharacterBody2D):
	owner_node = player

func perform_attack():
	pass

func get_attack_animation_name() -> String:
	return ""

func reset_combo() -> void:
	combo_count = 0
	attack_buffered = false
	combo_reset.emit()

func increment_combo() -> void:
	combo_count += 1
	if combo_count == 1:
		combo_window_timer = combo_window_duration
