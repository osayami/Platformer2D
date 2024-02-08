extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var jumo_force := 300

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animated_sprite.play("jump")
		body.jump(jumo_force)
