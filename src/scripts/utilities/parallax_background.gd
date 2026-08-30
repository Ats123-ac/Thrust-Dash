extends ParallaxBackground
## Simple script that manages the parallax background

func _process(delta: float) -> void:
	scroll_offset.x -= 60 * delta
