extends CharacterBody2D

const VIDA: int = 150
const SPEED: float = 200
const ALIMENTO: int = 20

var grupo: Data.GRUPO = Data.GRUPO.SALVAJE
var hogar: Node = null
var vida: int = VIDA

func initialize(el_grupo: Data.GRUPO, casa: Node) -> void:
	grupo = el_grupo
	hogar = casa
	$Imagen.initialize_warrior(grupo)

func get_grupo() -> Data.GRUPO:
	return grupo

func get_hogar_grupo() -> Data.GRUPO:
	if hogar != null:
		return hogar.grupo
	return Data.GRUPO.SALVAJE

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)

func is_alimentable() -> bool:
	return vida < VIDA

func _physics_process(_delta: float) -> void:
	move_and_slide()
