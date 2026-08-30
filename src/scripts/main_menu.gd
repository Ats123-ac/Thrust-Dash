class_name MainMenu
extends Control

## Path to your main game level scene
@export_file("*.tscn") var start_level_path: String = "res://scenes/level.tscn"

## Opacity for the top background layer (0.0 = completely clear, 1.0 = fully solid)
@export_range(0.0, 1.0) var top_bg_opacity: float = 0.5

@onready var background_top: TextureRect = $BackgroundTop
@onready var start_button: Button = $VBoxContainer2/StartButton
@onready var quit_button: Button = $VBoxContainer2/Quitbutton


func _ready() -> void:
	# Ensure time scale is active when loading into the menu from a paused death screen
	get_tree().paused = false
	
	# Apply transparency to the upper background layer
	if background_top:
		background_top.self_modulate.a = top_bg_opacity
	
	# Connect UI button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Focus the play button automatically for keyboard/controller navigation
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	if ResourceLoader.exists(start_level_path):
		get_tree().change_scene_to_file(start_level_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
