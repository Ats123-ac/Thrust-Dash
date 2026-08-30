class_name WoodBox
extends DestructibleActor


func _ready() -> void:
	super()
	if sprite is Sprite2D:
		sprite.frame = randi_range(0, sprite.hframes-1)
