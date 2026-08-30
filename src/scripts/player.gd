class_name Player
extends CharacterBody2D

signal death
signal hurt(damage: int)
signal health_changed(current_health: int, max_health: int)

@export var propulsion_strength: float = 50.0
@export var max_propulsion: float = 750.0
@export var hitflash_duration: float = 0.2
@export var invincibility_duration: float = 1.5
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


func _ready() -> void:
	cur_health = max_health
	invincible = false
	
	# Reset shader variables on start to prevent the white skin glitch on restart
	if sprite and sprite.material is ShaderMaterial:
		var shader: ShaderMaterial = sprite.material as ShaderMaterial
		shader.set_shader_parameter(&'is_invincible', false)
		shader.set_shader_parameter(&'is_hit', false)
	
	# Safely push 3 HP to UI after nodes are initialized
	call_deferred("_emit_initial_health")


func _emit_initial_health() -> void:
	health_changed.emit(cur_health, max_health)


func shoot() -> void:
	gun_particles.set_emitting(true)
	gun_raycast.set_enabled(true)
	velocity.y -= propulsion_strength
	if velocity.y < -max_propulsion:
		velocity.y = -max_propulsion


func activate_invinc() -> void:
	invincible = true
	var shader: ShaderMaterial = sprite.material as ShaderMaterial if sprite else null
	if shader:
		shader.set_shader_parameter(&'is_invincible', true)
		
	await get_tree().create_timer(invincibility_duration).timeout
	
	if shader:
		shader.set_shader_parameter(&'is_invincible', false)
	invincible = false


func activate_hitflash() -> void:
	var shader: ShaderMaterial = sprite.material as ShaderMaterial if sprite else null
	if shader:
		shader.set_shader_parameter(&'is_hit', true)
	await get_tree().create_timer(hitflash_duration).timeout
	if shader:
		shader.set_shader_parameter(&'is_hit', false)


func take_damage(damage: int) -> void:
	if invincible or cur_health <= 0:
		return
		
	print("1. PLAYER HIT! Health dropping to: ", cur_health - damage)
	
	cur_health -= damage
	health_changed.emit(cur_health, max_health)
	
	activate_hitflash()
	
	if cur_health <= 0:
		# Disable player collision so hazards stop triggering continuous hits
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Emit death signal to trigger the death screen UI cleanly
		emit_signal(&'death')
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
		if collider:
			var destructible: DestructibleActor = (
				collider.get_parent() as DestructibleActor)
			if destructible is DestructibleActor:
				destructible.destroy()
	play_animations()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	move_and_slide()
