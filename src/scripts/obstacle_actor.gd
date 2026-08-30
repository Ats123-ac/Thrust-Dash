class_name ObstacleActor
extends Actor

@export var damage: int = 1

@export var score: int = 1


func take_action(body: Node2D) -> void:
	if not body is Player:
		pass
	# this probably should be seperated into it's own subclass (or component)
	# but for how few lines of code it takes I might as well just add it here.
	elif self.is_in_group(&'Coin'):
		# add to score
		queue_free()
	elif not (body as Player).invincible:
		(body as Player).take_damage(damage)
		queue_free()

func _ready() -> void:
	super()
	if collider is Area2D:
		(collider as Area2D).connect(&'body_entered', take_action)
