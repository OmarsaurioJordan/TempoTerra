extends Area2D

const SPEED: float = 600
const ALCANCE: float = 1000

var multiplo_speed: float = 1
var grupo: Data.GRUPO = Data.GRUPO.SOLO
var desvanecer : float = 1
var direccion: Vector2 = Vector2(0, 0)

func initialize(new_parent: Node, el_grupo: Data.GRUPO, la_direccion: Vector2,
		ind_tech: int, posicion: Vector2) -> void:
	visible = true
	call_deferred("activar_colision")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	grupo = el_grupo
	direccion = la_direccion
	desvanecer = 1
	modulate = Color(1, 1, 1, 1)
	$Imagen.frame = ind_tech
	$TimFin.start(ALCANCE / SPEED)
	global_position = posicion
	match ind_tech:
		0: # roca
			multiplo_speed = 0.8
		1: # lanza
			multiplo_speed = 0.9
		2: # flecha
			multiplo_speed = 1
		3: # balin
			multiplo_speed = 1.1
		4: # bala
			multiplo_speed = 1.2
		5: # energia
			multiplo_speed = 1.3

func activar_colision() -> void:
	monitoring = true

func _physics_process(delta: float) -> void:
	if visible:
		position += direccion * SPEED * multiplo_speed * delta
		if $TimFin.is_stopped():
			desvanecer = max(0, desvanecer - delta)
			if desvanecer == 0:
				call_deferred("finalizar")
			else:
				modulate = Color(1, 1, 1, desvanecer)

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() == get_parent():
		if body.get_hogar_grupo() != grupo:
			body.hit_proyectil($Imagen.frame, direccion)
			call_deferred("finalizar")

func _on_area_entered(_area: Area2D) -> void:
	call_deferred("finalizar")

func finalizar() -> void:
	monitoring = false
	global_position = Vector2(0, 0)
	visible = false
