class_name Actor
extends CharacterBody2D

@export var movement_speed_factor: float = 200.0

var sprite: Sprite2D

var collider: Area2D

var anim_player: AnimationPlayer


func _physics_process(_delta: float) -> void:
	velocity.x = -movement_speed_factor
	move_and_slide()
	# if the actors goes past the left screen, free them
	if global_position.x < -50.0:
		queue_free()


func _ready() -> void:
	# because i'm not using composition, I need to manually get a reference to
	# possible existing child nodes for child classes to use. this unfortunately
	# means that these lines can't be type-hinted as get_node_or_null isn't 
	# guaranteed to return an object.
	#
	# another solid reason why I should have just used composition.
	sprite = get_node_or_null('Sprite2D')
	collider = get_node_or_null('Collider')
	anim_player = get_node_or_null('AnimationPlayer')
	if anim_player is AnimationPlayer:
		(anim_player as AnimationPlayer).play(&'main')
