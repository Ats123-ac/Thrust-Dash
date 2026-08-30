class_name DeathScreen
extends CanvasLayer

## Path to your Main Menu scene file
@export_file("*.tscn") var main_menu_path: String = "res://scenes/main_menu.tscn"

# Use find_child so it locates the buttons regardless of container layout
@onready var restart_button: Button = find_child("RestartButton", true, false) as Button
@onready var main_button: Button = find_child("Mainbutton", true, false) as Button


func _ready() -> void:
	# Process mode MUST be set to Always so UI buttons work while get_tree().paused is true
	process_mode = PROCESS_MODE_ALWAYS
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if main_button:
		main_button.pressed.connect(_on_main_button_pressed)


func show_death_screen() -> void:
	visible = true
	get_tree().paused = true
	if restart_button:
		restart_button.grab_focus()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_button_pressed() -> void:
	get_tree().paused = false
	if ResourceLoader.exists(main_menu_path):
		get_tree().change_scene_to_file(main_menu_path)
