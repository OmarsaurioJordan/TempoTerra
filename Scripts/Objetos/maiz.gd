extends Sprite2D

const COSECHA_TIME_MIN: float = 60
const COSECHA_TIME_EXT: float = 10

func get_listo() -> bool:
	return frame == 10

func set_cosecha() -> bool:
	if get_listo():
		$Timer.start(COSECHA_TIME_MIN + randf() * COSECHA_TIME_EXT)
		frame = 11
		return true
	return false

func _on_timer_timeout() -> void:
	frame = 10
