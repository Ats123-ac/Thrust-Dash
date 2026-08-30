class_name DestructibleActor
extends Actor

@export var hitflash_duration: float = 0.2

@onready var gravity: int = (
	ProjectSettings.get_setting('physics/2d/default_gravity') as int)


func activate_hitflash() -> void:
	if sprite is Sprite2D:
		var shader: ShaderMaterial = sprite.get_material() as ShaderMaterial
		shader.set_shader_parameter(&'is_hit', true)
		await get_tree().create_timer(hitflash_duration).timeout
		shader.set_shader_parameter(&'is_hit', false)


func destroy() -> void:
	await activate_hitflash()
	queue_free()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	super(delta)
