class_name Player
extends CharacterBody2D
## Represents the player-controlled character in the game.

signal death

signal hurt(damage: int)

@export var propulsion_strength: float = 50.0

@export var max_propulsion: float = 750.0

@export var hitflash_duration: float = 0.2

@export var invincibility_duration: float = 3.0

@export var max_health: int = 3

@onready var cur_health: int = max_health

@onready var _gravity: int = (
	ProjectSettings.get_setting('physics/2d/default_gravity') as int)

@onready var gun_particles: GPUParticles2D = (
	$GunPack/GPUParticles2D as GPUParticles2D)

@onready var gun_raycast: ShapeCast2D = (
	$GunPack/ShapeCast2D as ShapeCast2D)

@onready var sprite: Sprite2D = $Body as Sprite2D

@onready var anim_player: AnimationPlayer = (
	$AnimationPlayer as AnimationPlayer)

var invincible: bool = false


func shoot() -> void:
	gun_particles.set_emitting(true)
	gun_raycast.set_enabled(true)
	velocity.y -= propulsion_strength
	if velocity.y < -max_propulsion:
		velocity.y = -max_propulsion


func activate_invinc() -> void:
	var shader: ShaderMaterial = sprite.get_material() as ShaderMaterial
	shader.set_shader_parameter(&'is_invincible', true)
	invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	shader.set_shader_parameter(&'is_invincible', false)
	invincible = false


func activate_hitflash() -> void:
	var shader: ShaderMaterial = sprite.get_material() as ShaderMaterial
	shader.set_shader_parameter(&'is_hit', true)
	await get_tree().create_timer(hitflash_duration).timeout
	shader.set_shader_parameter(&'is_hit', false)


func take_damage(damage: int) -> void:
	cur_health -= damage
	await activate_hitflash()
	if cur_health <= 0: 
		emit_signal(&'death')
		#queue_free()
		get_tree().quit()
	else:
		emit_signal(&'hurt', damage)
		activate_invinc()


func play_animations() -> void:
	if Input.is_action_pressed('hover'):
		anim_player.play(&'fly')
	elif is_on_floor():
		anim_player.play(&'walk')
	else:
		anim_player.play(&'RESET')


func _process(_delta: float) -> void:
	if Input.is_action_pressed('hover'):
		shoot()
	else:
		gun_particles.set_emitting(false)
		gun_raycast.set_enabled(false)
	if gun_raycast.is_colliding() and not gun_raycast.get_collider(0) == null:
		var collider: Area2D = gun_raycast.get_collider(0) as Area2D
		var destructible: DestructibleActor = (
			collider.get_parent() as DestructibleActor)
		if destructible is DestructibleActor:
			destructible.destroy()
	play_animations()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	move_and_slide()
