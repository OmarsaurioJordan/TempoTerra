extends StaticBody2D

@export var grupo: Data.GRUPO = Data.GRUPO.SALVAJE

func _ready() -> void:
	$Imagen.frame = grupo

func get_grupo() -> Data.GRUPO:
	return grupo
