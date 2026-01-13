extends Area2D

const SPEED: float = 500

var grupo: Data.GRUPO = Data.GRUPO.SOLO
var direccion: Vector2 = Vector2(0, 0)

func initialize(el_grupo: Data.GRUPO, trayecto: Vector2, is_granada: bool) -> void:
	grupo = el_grupo
	direccion = trayecto.normalized()
	if is_granada:
		$Imagen.frame = 1
	else:
		$Imagen.frame = 0
	$TimFin.start(trayecto.length() / SPEED)

func _physics_process(delta: float) -> void:
	position += direccion * SPEED * delta
	if $TimFin.is_stopped():
		# Tarea explotar
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() == get_parent():
		if body.get_hogar_grupo() != grupo:
			direccion = body.global_position.direction_to(global_position)

func _on_area_entered(area: Area2D) -> void:
	direccion = area.global_position.direction_to(global_position)
