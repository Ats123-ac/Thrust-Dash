extends Node2D

signal collected(points: int)


func _ready() -> void:
	# Connect every coin child inside this cluster
	for child in get_children():
		# Check if child (or its collider) has the collected signal
		var coin_target: Node = child
		if not coin_target.has_signal("collected"):
			for subchild in child.get_children():
				if subchild.has_signal("collected"):
					coin_target = subchild
					break
		
		if coin_target.has_signal("collected"):
			coin_target.connect("collected", _on_child_coin_collected)


func _on_child_coin_collected(points: int = 1) -> void:
	# Relay signal up to factory.gd
	collected.emit(points)
