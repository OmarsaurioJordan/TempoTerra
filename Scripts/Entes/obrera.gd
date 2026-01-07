extends CharacterBody2D

const VIDA: int = 100
const VISION_MAIZ: float = 500 # radio minimo, se incrementara multiplicandolo en un ciclo
const VISION: float = 1000
const SPEED: float = 100
const ALIMENTO: int = 10

enum ESTADO { LIBRE, CHARLANDO, REPRODUCCION, RECOLECCION, ALIMENTACION }

var estado: ESTADO = ESTADO.LIBRE
var grupo: Data.GRUPO = Data.GRUPO.SALVAJE
var hogar: Node = null
var vida: int = int(VIDA / 2)

# para navegacion, puede ser perseguir cualquier tipo de nodo
var meta: Vector2 = Vector2(0, 0) # punto al que se desea llegar
var objetivo: Node = null # nodo al que se desea llegar
var next_calle: Node = null # proxima calle para llegar a la final
var obj_calle: Node = null # calle final que conecta con objetivo
var mover_errar: bool = false # para saber si esta en ciclo de movimiento

func initialize(el_grupo: Data.GRUPO, casa: Node) -> void:
	grupo = el_grupo
	hogar = casa
	$Imagen.initialize_obrera(grupo)
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
				set_estado(ESTADO.RECOLECCION) # quitar
			ESTADO.CHARLANDO:
				pass
			ESTADO.REPRODUCCION:
				pass
			ESTADO.RECOLECCION:
				est_recoleccion()
			ESTADO.ALIMENTACION:
				est_alimentacion()
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
	return vida < VIDA / 2

func set_estado(new_estado: ESTADO) -> void:
	estado = new_estado
	objetivo = null
	next_calle = null
	meta = Vector2(0, 0)
	velocity = Vector2(0, 0)
	$Imagen/Bolsa.visible = false
	$Imagen/Alimento.visible = false
	$Imagen/Huevo.visible = false
	match estado:
		ESTADO.LIBRE:
			pass
		ESTADO.CHARLANDO:
			pass
		ESTADO.REPRODUCCION:
			$Imagen/Huevo.visible = true
		ESTADO.RECOLECCION:
			$Imagen/Bolsa.visible = true
		ESTADO.ALIMENTACION:
			$Imagen/Alimento.visible = true
			$Imagen/Alimento.frame = 1
			$TimEstado.start(randf_range(3, 4))

func est_recoleccion() -> void:
	# si no hay casa a donde entregar el maiz, abortar estado
	if not is_hogar_grupo():
		set_estado(ESTADO.LIBRE)
	# cuando ya tiene algo en mano, lo va a procesar en casa y cambia de estado
	elif $Imagen/Alimento.visible:
		if $Imagen/Alimento.frame == 0:
			objetivo = hogar
			if Data.mover_hacia_objetivo(self, 125) == Data.RES_MOVE.LLEGO:
				$Imagen/Alimento.frame = 1
				$TimPausa.start()
		else:
			set_estado(ESTADO.ALIMENTACION)
	elif objetivo == null:
		# buscar maiz en el campo
		var maicez = get_tree().get_nodes_in_group("maicez")
		for i in range(maicez.size() - 1, -1, -1):
			if not maicez[i].get_listo():
				maicez.remove_at(i)
		var los_mios: Array = []
		for i in range(1, 6):
			los_mios = Data.get_envista(self, maicez, VISION_MAIZ * i)
			if not los_mios.is_empty():
				break
		if los_mios.is_empty():
			set_estado(ESTADO.LIBRE)
		else:
			objetivo = los_mios.pick_random()
			$TimPausa.start()
	# ir por el maiz que ya vio
	elif Data.mover_hacia_objetivo(self, 50) == Data.RES_MOVE.LLEGO:
		if objetivo.set_cosecha():
			$Imagen/Alimento.visible = true
			$Imagen/Alimento.frame = 0
			$TimPausa.start()
		objetivo = null

func est_alimentacion() -> void:
	if $TimEstado.is_stopped():
		$TimEstado.start(randf_range(3, 4))
		if objetivo == null:
			alimentar()
			if vida == VIDA:
				vida = int(VIDA / 2)
				set_estado(ESTADO.REPRODUCCION)
			else:
				set_estado(ESTADO.LIBRE)
	elif objetivo != null:
		if Data.mover_hacia_objetivo(self, 60) == Data.RES_MOVE.LLEGO:
			if objetivo.is_alimentable():
				objetivo.alimentar()
				set_estado(ESTADO.LIBRE)
			objetivo = null
	else:
		errar()
		# cada tanto buscar aliado que requiera ayuda
		if is_hogar_grupo():
			if randf() > Data.ESTOCASTICO:
				var entes = get_tree().get_nodes_in_group("humans")
				var envista = Data.get_envista(self, entes, VISION)
				if not envista.is_empty():
					var mi_hogar_grupo = get_hogar_grupo()
					for i in range(envista.size() - 1, -1, -1):
						if envista[i].get_hogar_grupo() != mi_hogar_grupo or\
								not envista[i].is_alimentable():
							envista.remove_at(i)
				if not envista.is_empty():
					objetivo = envista.pick_random()

func _on_tim_errar_timeout() -> void:
	$TimErrar.start(randf_range(1, 7))
	mover_errar = not mover_errar
