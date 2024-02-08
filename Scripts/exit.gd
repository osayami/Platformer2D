extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


	
func animate():
	animated_sprite.play("default")
