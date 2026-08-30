extends CanvasLayer

@onready var health_bar: ProgressBar = $TopLeftContainer/VBoxContainer/HealthBar
@onready var score_label: Label = $TopLeftContainer/VBoxContainer/ScoreLabel
@onready var pause_button: Button = $TopLeftContainer/VBoxContainer/PauseButton

var score: int = 0


func _ready() -> void:
	# Adds this UI to a group so other nodes can find it easily if needed
	add_to_group("UI")
	
	if pause_button:
		pause_button.pressed.connect(_on_pause_button_pressed)
		
	# Configure the health bar's limits when the level starts
	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = 3
		health_bar.step = 1
		health_bar.value = 3
	
	update_score_display()


func update_health(amount: int) -> void:
	print("3. UI SCRIPT TRIGGERED! Changing bar value to: ", amount)
	if health_bar:
		health_bar.value = amount


func update_score(points: int = 1) -> void:
	score += points
	update_score_display()


func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: " + str(score)


func _on_pause_button_pressed() -> void:
	# If Level script connects PauseButton directly to PauseMenu, avoid instantiating a duplicate
	var pause_menu: Node = get_node_or_null("../PauseMenu")
	if pause_menu and pause_menu.has_method("show_menu"):
		pause_menu.show_menu()
	else:
		get_tree().paused = true
		var pause_scene = load("res://scenes/PauseMenu.tscn").instantiate()
		add_child(pause_scene)


func show_death_screen() -> void:
	print("Showing death screen...")
	get_tree().paused = true
	
	# Fetch the DeathScreen node directly from the scene tree instead of invalid get_node_or_null file path
	var death_screen_node: Node = get_node_or_null("../DeathScreen")
	if death_screen_node:
		death_screen_node.visible = true
