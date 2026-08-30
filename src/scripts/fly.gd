class_name Fly
extends ObstacleActor

@export var amplitude: float = 100.0

@export var frequency: float = 100.0


func _physics_process(delta: float) -> void:
	velocity.y = amplitude * sin(1/frequency * Time.get_ticks_msec())
	super(delta)
