class_name ObstacleActor
extends Actor

signal collected(points: int)

@export var damage: int = 1
@export var score: int = 1


func _ready() -> void:
	super()
	# Check for the child 'Collider' node (Area2D) safely using get_node_or_null
	var area_collider: Area2D = get_node_or_null("Collider") as Area2D
	if area_collider:
		area_collider.body_entered.connect(take_action)


func take_action(body: Node2D) -> void:
	if not body is Player:
		return

	if is_in_group(&'Coin'):
		collected.emit(score)
		queue_free()
	elif not (body as Player).invincible:
		(body as Player).take_damage(damage)
		queue_free()
