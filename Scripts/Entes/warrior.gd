extends CharacterBody2D

const VIDA: int = 150 # cantidad de puntos de impacto
const SPEED: float = 150 # velocidad de desplazamiento
const ALIMENTO: int = 20 # en cuanto aumenta su vida al ser alimentado
const VISION: float = 1000 # rango de vision para otros entes o cosas

enum ESTADO { LIBRE, SEGUIR, EXPLORAR, CONQUISTAR, RECARGAR, MISION }
enum POSTURA { HOGAR, EXTRA, SOBRA }

var estado: ESTADO = ESTADO.LIBRE
var grupo: Data.GRUPO = Data.GRUPO.SALVAJE
var hogar: Node = null
var vida: int = VIDA
var municion: int = 0
var especial: int = 0 # municion especial
var mision: Node = null # la base o casa a la cual atacar o defender
var enemigo: Node = null # a quien tiene en mira para atacar

# para navegacion, puede ser perseguir cualquier tipo de nodo
var meta: Vector2 = Vector2(0, 0) # punto al que se desea llegar
var objetivo: Node = null # nodo al que se desea llegar
var next_calle: Node = null # proxima calle para llegar a la final
var obj_calle: Node = null # calle final que conecta con objetivo
var mover_errar: bool = false # para saber si esta en ciclo de movimiento
var huida_giro: float = 0 # para esquivar al huir

func initialize(el_grupo: Data.GRUPO, casa: Node) -> void:
	grupo = el_grupo
	hogar = casa
	$Imagen.initialize_warrior(grupo)
	set_estado(ESTADO.LIBRE)

func get_hogar() -> Node:
	return hogar

func get_hogar_grupo() -> Data.GRUPO:
	if hogar != null:
		return hogar.grupo
	return Data.GRUPO.SALVAJE

func is_hogar_grupo() -> bool:
	return get_hogar_grupo() != Data.GRUPO.SALVAJE

func get_grupo() -> Data.GRUPO:
	return grupo

func get_base() -> Node:
	if is_hogar_grupo():
		var bases = get_tree().get_nodes_in_group("bases")
		var hogar_grupo = get_hogar_grupo()
		for b in bases:
			if b.get_grupo() == hogar_grupo:
				return b
	return null

func get_postura() -> POSTURA:
	if hogar != null:
		var i = hogar.get_postura(self, false)
		if i <= 0:
			return POSTURA.HOGAR
		elif i == 1:
			return POSTURA.EXTRA
		return POSTURA.SOBRA
	return POSTURA.HOGAR

func is_mele() -> bool:
	return $Imagen/Arma.visible

func _physics_process(_delta: float) -> void:
	var bueno_dale = true
	if enemigo != null:
		if is_instance_valid(enemigo):
			match estado:
				ESTADO.LIBRE, ESTADO.EXPLORAR, ESTADO.MISION:
					est_bailewar()
					bueno_dale = false
				ESTADO.RECARGAR:
					est_recargar()
					var dir = velocity.normalized() +\
						enemigo.global_position.direction_to(global_position).rotated(huida_giro)
					velocity = dir.normalized() * SPEED
					bueno_dale = false
		else:
			enemigo = null
	if bueno_dale:
		if $TimPausa.is_stopped():
			match estado:
				ESTADO.LIBRE:
					est_libre()
				ESTADO.SEGUIR:
					est_seguir()
				ESTADO.EXPLORAR:
					est_explorar()
				ESTADO.CONQUISTAR:
					est_conquistar()
				ESTADO.RECARGAR:
					est_recargar()
				ESTADO.MISION:
					est_mision()
		else:
			velocity = Vector2(0, 0)
	move_and_slide()
	# buscar con quien pelear
	if Data.go_estocastico() and enemigo == null:
		ver_enemigo()

func ver_enemigo() -> void:
	if not enemigo_de_grupo("aliens"):
		if not enemigo_de_grupo("monstruos"):
			pass

func enemigo_de_grupo(grupo_str: String) -> bool:
	var entes = get_tree().get_nodes_in_group(grupo_str)
	if is_mele():
		var visto = Data.get_nearest(self, entes, VISION)
		if visto != null:
			enemigo = visto
			return true
	else:
		var vistos = Data.get_envista(self, entes, VISION)
		if not vistos.is_empty():
			enemigo = vistos.pick_random()
			return true
	return false

func est_bailewar() -> void:
	# funcion llamada solo si enemigo ha sido verificado
	# verificar si lo alcanza a ver
	
	# moverse bailando cerca a enemigo
	if is_mele():
		Data.seguir_punto(self, enemigo.global_position, 125, 75)
	else:
		Data.seguir_punto(self, enemigo.global_position, VISION * 0.8, VISION * 0.5)
	if velocity.is_zero_approx():
		if not mover_errar:
			mover_errar = true
		errar()

func errar() -> void:
	if mover_errar:
		if meta.is_zero_approx():
			var solidos = get_tree().get_nodes_in_group("buildings")
			var pp = global_position + Vector2(randf() * VISION, 0).rotated(randf() * 2 * PI)
			if is_hogar_grupo():
				var mis_edif = []
				var mi_grupo = get_hogar_grupo()
				for sol in solidos:
					if sol.get_grupo() == mi_grupo:
						mis_edif.append(sol)
				if not mis_edif.is_empty():
					pp = mis_edif.pick_random().global_position +\
						Vector2(randf() * VISION, 0).rotated(randf() * 2 * PI)
			if Data.is_punto_free(self, pp, solidos):
				meta = pp
		elif Data.mover_hacia_punto(self, meta, 75) == Data.RES_MOVE.LLEGO:
			# llego al punto dado
			meta = Vector2(0, 0)
	elif global_position.distance_to(meta) > VISION * 2 and not meta.is_zero_approx():
		Data.mover_hacia_punto(self, meta, 75)
	else:
		velocity = Vector2(0, 0)

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)

func is_alimentable() -> bool:
	return vida < VIDA

func is_libre() -> bool:
	return estado == ESTADO.LIBRE

func set_estado(new_estado: ESTADO, ext_info=null) -> void:
	estado = new_estado
	objetivo = null
	next_calle = null
	meta = Vector2(0, 0)
	velocity = Vector2(0, 0)
	$TimEstado.stop()
	match estado:
		ESTADO.LIBRE:
			$TimEstado.start(randf_range(3, 6))
		ESTADO.SEGUIR:
			if ext_info == null:
				set_estado(ESTADO.LIBRE)
			else:
				objetivo = ext_info
		ESTADO.EXPLORAR:
			var calles = get_parent().get_parent().get_node("Limites/Navegacion").get_children()
			objetivo = calles.pick_random()
		ESTADO.CONQUISTAR:
			pass
		ESTADO.RECARGAR:
			pass
		ESTADO.MISION:
			var base = get_base()
			if base == null:
				set_estado(ESTADO.LIBRE)
			else:
				mision = base.get_mision()
				if mision == null:
					var edif = get_tree().get_nodes_in_group("buildings")
					var hogar_grupo = get_hogar_grupo()
					for i in range(edif.size() -1, -1, -1):
						if edif[i].get_grupo() == hogar_grupo:
							edif.remove_at(i)
					if edif.is_empty():
						var calles = get_parent().get_parent().get_node(
							"Limites/Navegacion").get_children()
						mision = calles.pick_random()
					else:
						mision = edif.pick_random()

func est_libre() -> void:
	errar()
	if $TimEstado.is_stopped():
		var base = get_base()
		if base != null:
			var pos = get_postura()
			match base.get_diplomacia():
				Data.DIPLOMACIA.NORMAL:
					if pos == POSTURA.SOBRA:
						set_estado(ESTADO.EXPLORAR)
					else:
						$TimEstado.start(randf_range(3, 6))
				Data.DIPLOMACIA.ATAQUE:
					if pos == POSTURA.SOBRA:
						set_estado(ESTADO.MISION)
					else:
						$TimEstado.start(randf_range(3, 6))
				Data.DIPLOMACIA.DEFENSA, Data.DIPLOMACIA.GUERRA:
					if pos != POSTURA.HOGAR:
						set_estado(ESTADO.MISION)
					else:
						$TimEstado.start(randf_range(3, 6))
				Data.DIPLOMACIA.EXPLORA:
					if pos != POSTURA.HOGAR:
						set_estado(ESTADO.EXPLORAR)
					else:
						$TimEstado.start(randf_range(3, 6))
		else:
			$TimEstado.start(randf_range(3, 6))

func est_seguir() -> void:
	match Data.seguir_objetivo(self, 150, 100):
		Data.RES_MOVE.NULO:
			set_estado(ESTADO.LIBRE)
		Data.RES_MOVE.FALTA:
			if Data.go_estocastico():
				if false: # Tarea revisar player
					set_estado(ESTADO.LIBRE)

func est_explorar() -> void:
	if objetivo != null:
		if Data.mover_hacia_objetivo(self, 150) == Data.RES_MOVE.LLEGO:
			objetivo = null
			$TimEstado.start(randf_range(20, 30))
			$TimPausa.start(randf_range(1, 3))
	elif $TimEstado.is_stopped():
		$TimPausa.start(randf_range(1, 3))
		set_estado(ESTADO.LIBRE)
	else:
		errar()

func est_conquistar() -> void:
	pass

func est_recargar() -> void:
	pass

func est_mision() -> void:
	if mover_errar:
		if meta.is_zero_approx():
			var pp = mision.global_position +\
				Vector2(randf() * VISION, 0).rotated(randf() * 2 * PI)
			var solidos = get_tree().get_nodes_in_group("buildings")
			if Data.is_punto_free(self, pp, solidos):
				meta = pp
		elif Data.mover_hacia_punto(self, meta, 75) == Data.RES_MOVE.LLEGO:
			# llego al punto dado
			meta = Vector2(0, 0)
	elif global_position.distance_to(meta) > VISION * 1.5 and not meta.is_zero_approx():
		Data.mover_hacia_punto(self, meta, 75)
	else:
		velocity = Vector2(0, 0)

func _on_tim_errar_timeout() -> void:
	$TimErrar.start(randf_range(1, 7))
	mover_errar = not mover_errar
	huida_giro = randf_range(-PI * 0.25, PI * 0.25)

func base_cambia_diplomacia(base: Node) -> void:
	if base == get_base():
		set_estado(ESTADO.LIBRE)

func _on_tim_ver_timeout() -> void:
	$TimVer.start(randf_range(4, 8))
	ver_enemigo()
