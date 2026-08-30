class_name DebugMenu
extends CanvasLayer
## Simple debug menu

@export var player: Player

var _label: Label


func _ready() -> void:
	_label = Label.new()
	add_child(_label)

func _process(_delta: float) -> void:
	_label.set_text(
		'''
		FPS: %s\n
		Health: %s\n
		Velocity: %s\n
		''' % [
			str(Engine.get_frames_per_second()),
			str(player.cur_health),
			str(player.velocity),]
	)
