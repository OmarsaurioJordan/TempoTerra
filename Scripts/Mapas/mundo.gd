extends Node2D

func _ready() -> void:
	randomize()
	Engine.time_scale = 1.0
	call_deferred("initialize")

func initialize() -> void:
	var pareja = [load("res://Scenes/Entes/warrior.tscn"), load("res://Scenes/Entes/obrera.tscn")]
	for ca in get_tree().get_nodes_in_group("casas"):
		for _r in range(2):
			for par in pareja:
				var aux = par.instantiate()
				ca.get_parent().add_child(aux)
				aux.position = ca.position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var bases = get_tree().get_nodes_in_group("bases")
	var casas = get_tree().get_nodes_in_group("casas")
	for ent in get_tree().get_nodes_in_group("humans"):
		var near = Data.get_nearest(ent, bases)
		ent.initialize(near.get_grupo(), Data.get_nearest(ent, casas))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_clock_max"):
		if Data.DEBUG:
			Engine.time_scale = min(Engine.time_scale + 1, 5)
	elif event.is_action_pressed("ui_clock_min"):
		if Data.DEBUG:
			Engine.time_scale = max(Engine.time_scale - 1, 0)
