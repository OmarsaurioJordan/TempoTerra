extends CharacterBody2D

const VIDA: int = 150 # cantidad de puntos de impacto
const SPEED: float = 200 # velocidad de desplazamiento
const ALIMENTO: int = 20 # en cuanto aumenta su vida al ser alimentado
const VISION: float = 1000 # rango de vision para otros entes o cosas

enum ESTADO { LIBRE, SEGUIR, EXPLORAR, ATACAR, CONQUISTAR, RECARGAR }

var estado: ESTADO = ESTADO.LIBRE
var grupo: Data.GRUPO = Data.GRUPO.SALVAJE
var hogar: Node = null
var vida: int = VIDA

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

func _physics_process(_delta: float) -> void:
	if $TimPausa.is_stopped():
		match estado:
			ESTADO.LIBRE:
				est_libre()
			ESTADO.SEGUIR:
				est_seguir()
			ESTADO.EXPLORAR:
				est_explorar()
			ESTADO.ATACAR:
				est_atacar()
			ESTADO.CONQUISTAR:
				est_conquistar()
			ESTADO.RECARGAR:
				est_recargar()
	else:
		velocity = Vector2(0, 0)
	move_and_slide()

func errar() -> void:
	if mover_errar:
		if meta.is_zero_approx():
			var solidos = get_tree().get_nodes_in_group("bases")
			solidos.append_array(get_tree().get_nodes_in_group("casas"))
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
		ESTADO.ATACAR:
			pass
		ESTADO.CONQUISTAR:
			pass
		ESTADO.RECARGAR:
			pass

func est_libre() -> void:
	errar()
	if $TimEstado.is_stopped():
		var p = randf()
		if p < 0.5:
			set_estado(ESTADO.EXPLORAR)
		else:
			$TimEstado.start(randf_range(3, 6))

func est_seguir() -> void:
	match Data.seguir_objetivo(self, 150, 100):
		Data.RES_MOVE.NULO:
			set_estado(ESTADO.LIBRE)
		Data.RES_MOVE.FALTA:
			if randf() > Data.ESTOCASTICO:
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

func est_atacar() -> void:
	pass

func est_conquistar() -> void:
	pass

func est_recargar() -> void:
	pass

func _on_tim_errar_timeout() -> void:
	$TimErrar.start(randf_range(1, 7))
	mover_errar = not mover_errar
	huida_giro = randf_range(-PI * 0.25, PI * 0.25)
