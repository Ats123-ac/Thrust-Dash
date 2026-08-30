class_name Fly
extends ObstacleActor


func _physics_process(delta: float) -> void:
	# Keep vertical velocity steady
	velocity.y = 0.0
	super(delta)
