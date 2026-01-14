extends Node2D

func _ready() -> void:
	randomize()
	Engine.time_scale = 1.0
	call_deferred("initialize")

func initialize() -> void:
	var pareja = [load("res://Scenes/Entes/warrior.tscn"), load("res://Scenes/Entes/obrera.tscn")]
	for ca in get_tree().get_nodes_in_group("casas"):
		for par in pareja:
			var aux = par.instantiate()
			ca.get_parent().add_child(aux)
			aux.position = ca.position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var bases = get_tree().get_nodes_in_group("bases")
	var casas = get_tree().get_nodes_in_group("casas")
	for ent in get_tree().get_nodes_in_group("humans"):
		var near = Data.get_nearest(ent, bases)
		ent.initialize(near.get_grupo(), Data.get_nearest(ent, casas))
