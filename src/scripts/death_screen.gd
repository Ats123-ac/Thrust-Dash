extends CanvasLayer

@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var main_button: Button = $VBoxContainer/MainButton


func _ready() -> void:
	# Forces this node to update and accept input even when tree is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if main_button:
		main_button.pressed.connect(_on_main_pressed)


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
