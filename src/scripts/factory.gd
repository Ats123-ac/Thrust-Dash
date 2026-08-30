class_name Factory
extends Node2D

signal coin_collected(points: int)

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
		
		# Find the node with the 'collected' signal (Root or direct child)
		var target_node: Node = obj_inst
		if not target_node.has_signal("collected"):
			for child in obj_inst.get_children():
				if child.has_signal("collected"):
					target_node = child
					break
		
		if target_node.has_signal("collected"):
			target_node.connect("collected", _on_item_collected)
			
		get_parent().add_child(obj_inst)
		
	position = _inital_pos
	timer.start(spawn_time + randf_range(0.0, random_delay))


func _on_item_collected(points: int = 1) -> void:
	coin_collected.emit(points)


func _ready() -> void:
	_inital_pos = position
	timer.connect(&'timeout', spawn)
	add_child(timer)
	timer.start(spawn_time)
