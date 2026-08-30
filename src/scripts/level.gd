class_name Level
extends Node2D
## Represents a level in the game, handling factory objects and references.

@onready var player: Player = $Player
@onready var ui: CanvasLayer = $CanvasLayer
@onready var death_screen: Node = $DeathScreen
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var pause_button: Button = $CanvasLayer/TopLeftContainer/VBoxContainer/PauseButton
@onready var coin_factory: Node = $Factories/CoinFactory


func _ready() -> void:
	if player and ui:
		player.health_changed.connect(_on_player_health_changed)
		player.death.connect(_on_player_death)
	
	if coin_factory and ui:
		if coin_factory.has_signal("coin_collected"):
			coin_factory.coin_collected.connect(_on_coin_collected)
			
	# Connect pause button to pause menu
	if pause_button and pause_menu:
		pause_button.pressed.connect(_on_pause_button_pressed)
	elif not pause_menu:
		push_error("Level: PauseMenu node not found! Ensure PauseMenu.tscn is instanced under Level.")
			
	# Hide death screen at start
	if death_screen:
		death_screen.visible = false


func _on_player_health_changed(current: int, _max_hp: int) -> void:
	if ui.has_method("update_health"):
		ui.update_health(current)


func _on_player_death() -> void:
	get_tree().paused = true
	if death_screen:
		death_screen.visible = true


func _on_coin_collected(points: int = 1) -> void:
	if ui.has_method("update_score"):
		ui.update_score(points)


func _on_pause_button_pressed() -> void:
	if pause_menu:
		pause_menu.show_menu()
