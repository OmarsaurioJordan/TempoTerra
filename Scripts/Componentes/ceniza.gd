extends Node2D

const TIME_FIN: float = 720
var time_fin: float = 0

func _ready() -> void:
	set_process(false)

func initialize(new_parent: Node, posicion: Vector2) -> void:
	visible = true
	get_parent().remove_child(self)
	new_parent.add_child(self)
	time_fin = TIME_FIN
	modulate = Color(1, 1, 1, 1)
	global_position = posicion
	set_process(true)

func _process(delta: float) -> void:
	time_fin -= delta
	if time_fin <= 0:
		visible = false
		set_process(false)
	else:
		modulate = Color(1, 1, 1, time_fin / TIME_FIN)
