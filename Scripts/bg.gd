extends ParallaxBackground

@export var bg_texture : CompressedTexture2D = preload("res://Assets/textures/bg/Blue.png")
@onready var sprite: Sprite2D = $ParallaxLayer/Sprite2D
@export var scroll_speed := 12

func _ready() -> void:
	sprite.texture = bg_texture
	
func _process(delta: float) -> void:
	sprite.region_rect.position += delta * Vector2(scroll_speed , scroll_speed)
	if sprite.region_rect.position >= Vector2(64 , 64):
		sprite.region_rect.position = Vector2.ZERO
