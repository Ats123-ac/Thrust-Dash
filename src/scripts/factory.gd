class_name Factory
extends Node2D
## Object that instantiates other objects from scenes into the current scene.
## Mainly used for spawning obstacles that move across the screen

@export var object: PackedScene

@export var height_randomness: float = 0.0

@export var spawn_time: float = 2.0

@export var random_delay: float = 0.0

@onready var timer: Timer = Timer.new()

var _inital_pos: Vector2

func spawn() -> void:
	position.y += randf_range(0.0, height_randomness)
	if object:
		var obj_inst: Node2D = object.instantiate() as Node2D
		obj_inst.position = position
		get_parent().add_child(obj_inst)
	position = _inital_pos
	timer.start(spawn_time+randf_range(0.0, random_delay))

func _ready() -> void:
	_inital_pos = position
	timer.connect(&'timeout', spawn)
	add_child(timer)
	timer.start(spawn_time)
