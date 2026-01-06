extends CharacterBody2D

var grupo: Data.GRUPO = Data.GRUPO.SALVAJE

func initialize(el_grupo: Data.GRUPO) -> void:
	grupo = el_grupo
	$Imagen.initialize_warrior(grupo)

func get_grupo() -> Data.GRUPO:
	return grupo

func _physics_process(delta: float) -> void:
	move_and_slide()
