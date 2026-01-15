extends Area2D

const SPEED: float = 500
const RADIO: float = 64 # varios radios, esta es la distancia del minimo que se multiplicara

var grupo: Data.GRUPO = Data.GRUPO.SOLO
var direccion: Vector2 = Vector2(0, 0)

func _ready() -> void:
	set_physics_process(false)

func initialize(new_parent: Node, el_grupo: Data.GRUPO, trayecto: Vector2,
		is_granada: bool, posicion: Vector2) -> void:
	visible = true
	set_physics_process(true)
	call_deferred("activar_colision")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	grupo = el_grupo
	direccion = trayecto.normalized()
	if is_granada:
		$Imagen.frame = 1
	else:
		$Imagen.frame = 0
	$TimFin.start(trayecto.length() / SPEED)
	global_position = posicion

func activar_colision() -> void:
	monitoring = true

func _physics_process(delta: float) -> void:
	position += direccion * SPEED * delta
	if $TimFin.is_stopped():
		# hacer explosion
		var vapores = get_tree().get_nodes_in_group("vapores")
		var parnt = get_parent()
		var tipo = 2 if $Imagen.frame == 0 else 1
		var radios = 3 + $Imagen.frame
		Data.crea_vapor(parnt, global_position, tipo, vapores)
		for r in range(1, radios):
			var desf = randf() * 2.0 * PI
			var rad = RADIO * r
			var perim = 2.0 * PI * rad
			var vaps = ceil(perim / 80.0)
			var paso = 2.0 * PI / vaps
			for i in range(vaps):
				var ang = i * paso + desf + randf_range(-paso * 0.2, paso * 0.2)
				var lon = randf_range(rad * 0.8, rad * 1.2)
				Data.crea_vapor(parnt, global_position +
					Vector2(lon, 0).rotated(ang), tipo, vapores)
		# golpear a los entes
		var entes = get_tree().get_nodes_in_group("entes")
		var vistos = Data.get_envista(self, entes, RADIO * (radios - 1.5))
		for vis in vistos:
			var dir = global_position.direction_to(vis.global_position)
			vis.hit_explosion($Imagen.frame == 1, dir)
		call_deferred("finalizar")

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() == get_parent():
		if body.get_hogar_grupo() != grupo:
			direccion = body.global_position.direction_to(global_position)

func _on_area_entered(area: Area2D) -> void:
	direccion = area.global_position.direction_to(global_position)

func finalizar() -> void:
	monitoring = false
	global_position = Vector2(0, 0)
	visible = false
	set_physics_process(false)
