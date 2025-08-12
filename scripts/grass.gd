extends Area2D

var bend_speed := 0.35
var back_speed := 4.0
@export var skewvalue := 15.0


func _on_body_entered(body: Node2D) -> void:
	if body is Player or Enemy:
		var direction = global_position.direction_to(body.global_position)
		var skew1 = -direction.x * skewvalue
		
		var tween = create_tween()
		tween.tween_property($Sprite2D, "skew", skew1, bend_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		var tween2 = create_tween()
		tween2.tween_property($Sprite2D, "skew", 0.0, back_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
