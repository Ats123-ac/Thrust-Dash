class_name PauseMenu
extends CanvasLayer

@export_file("*.tscn") var main_menu_path: String = "res://scenes/main_menu.tscn"

@onready var resume_button: Button = find_child("ResumeButton", true, false) as Button
@onready var restart_button: Button = find_child("RestartButton", true, false) as Button
@onready var main_menu_button: Button = find_child("MainMenuButton", true, false) as Button


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	hide_menu()
	
	if resume_button:
		resume_button.pressed.connect(_on_resume_button_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	if get_tree().paused:
		hide_menu()
	else:
		show_menu()


func show_menu() -> void:
	visible = true
	get_tree().paused = true
	if resume_button:
		resume_button.grab_focus()


func hide_menu() -> void:
	visible = false
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	hide_menu()


func _on_restart_button_pressed() -> void:
	hide_menu()
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	hide_menu()
	if ResourceLoader.exists(main_menu_path):
		get_tree().change_scene_to_file(main_menu_path)
