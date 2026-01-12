extends Area2D

const SPEED: float = 600

var grupo: Data.GRUPO = Data.GRUPO.SOLO
var desvanecer : float = 1
var direccion: Vector2 = Vector2(0, 0)

func initialize(el_grupo: Data.GRUPO, la_direccion: Vector2, ind_tech: int) -> void:
	grupo = el_grupo
	direccion = la_direccion
	$Imagen.frame = ind_tech
	match ind_tech: # Tarea elegir velocidad y duracion
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass

func _physics_process(delta: float) -> void:
	position += direccion * SPEED * delta
	if $TimFin.is_stopped():
		desvanecer = max(0, desvanecer - delta)
		if desvanecer == 0:
			queue_free()
		else:
			modulate = Color(1, 1, 1, desvanecer)

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() == get_parent():
		if body.is_in_group("entes"):
			if body.get_hogar_grupo() != grupo:
				body.hit_proyectil($Imagen.frame)
				queue_free()
		else:
			queue_free()
