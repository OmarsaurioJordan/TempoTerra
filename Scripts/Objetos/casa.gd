extends StaticBody2D

var grupo: Data.GRUPO = Data.GRUPO.SALVAJE

func _ready() -> void:
	call_deferred("set_imagen")

func get_grupo() -> Data.GRUPO:
	return grupo

func set_imagen() -> void:
	var bases = get_tree().get_nodes_in_group("bases")
	var near = Data.get_nearest(self, bases)
	grupo = near.get_grupo()
	$Imagen.frame = Data.era_to_tech(Data.grupo_to_era(grupo))
