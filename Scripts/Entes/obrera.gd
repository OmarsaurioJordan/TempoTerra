extends CharacterBody2D

const WARRIOR = preload("res://Scenes/Entes/warrior.tscn")
const OBRERA = preload("res://Scenes/Entes/obrera.tscn")

const VIDA: int = 100 # cantidad de puntos de impacto
const VISION_MAIZ: float = 500 # radio minimo, se incrementara multiplicandolo en un ciclo
const VISION_MAIZ_MULT: int = 5 # multiplicador maximo para buscar maiz dada la distancia base
const VISION: float = 1000 # rango de vision para otros entes o cosas
const SPEED: float = 100 # velocidad de desplazamiento
const ALIMENTO: int = 10 # en cuanto aumenta su vida al ser alimentado
const INCUBACION: float = 60 # tiempo para crear nuevo individuo

enum ESTADO { LIBRE, CHARLANDO, REPRODUCCION, RECOLECCION, ALIMENTACION, SEGUIR }

var estado: ESTADO = ESTADO.LIBRE
var grupo: Data.GRUPO = Data.GRUPO.SOLO
var hogar: Node = null
var vida: int = int(VIDA / 2)

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
	$Imagen.initialize_obrera(grupo)
	set_estado(ESTADO.LIBRE)

func get_hogar() -> Node:
	return hogar

func get_hogar_grupo() -> Data.GRUPO:
	if hogar != null:
		return hogar.grupo
	return Data.GRUPO.SOLO

func is_hogar_grupo() -> bool:
	return get_hogar_grupo() != Data.GRUPO.SOLO

func get_grupo() -> Data.GRUPO:
	return grupo

func _physics_process(_delta: float) -> void:
	if $TimPausa.is_stopped():
		match estado:
			ESTADO.LIBRE:
				est_libre()
			ESTADO.CHARLANDO:
				est_charlando()
			ESTADO.REPRODUCCION:
				est_reproduccion()
			ESTADO.RECOLECCION:
				est_recoleccion()
			ESTADO.ALIMENTACION:
				est_alimentacion()
			ESTADO.SEGUIR:
				est_seguir()
	else:
		velocity = Vector2(0, 0)
	move_and_slide()

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
	else:
		velocity = Vector2(0, 0)

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)
	if vida == VIDA:
		vida = int(VIDA / 2)
		set_estado(ESTADO.REPRODUCCION)

func is_alimentable() -> bool:
	return vida < VIDA / 2

func is_libre() -> bool:
	return estado == ESTADO.LIBRE

func set_estado(new_estado: ESTADO, ext_info=null) -> void:
	estado = new_estado
	objetivo = null
	next_calle = null
	meta = Vector2(0, 0)
	velocity = Vector2(0, 0)
	$Imagen/Bolsa.visible = false
	$Imagen/Alimento.visible = false
	$Imagen/Huevo.visible = false
	$Imagen/Charlita.visible = false
	$TimEstado.stop()
	match estado:
		ESTADO.LIBRE:
			$TimEstado.start(randf_range(3, 6))
		ESTADO.CHARLANDO:
			if ext_info != null:
				objetivo = ext_info
				$TimEstado.start(30)
			else:
				var entes = get_tree().get_nodes_in_group("obreras")
				var envista = Data.get_envista(self, entes, VISION)
				if not envista.is_empty():
					var mi_hogar_grupo = get_hogar_grupo()
					for i in range(envista.size() - 1, -1, -1):
						if envista[i].get_hogar_grupo() != mi_hogar_grupo or\
								not envista[i].is_libre():
							envista.remove_at(i)
				if envista.is_empty():
					set_estado(ESTADO.LIBRE)
				else:
					objetivo = envista.pick_random()
					objetivo.set_estado(ESTADO.CHARLANDO, self)
					$TimEstado.start(30)
		ESTADO.REPRODUCCION:
			$Imagen/Huevo.visible = true
			$TimEstado.start(INCUBACION + randf_range(1, 5))
		ESTADO.RECOLECCION:
			$Imagen/Bolsa.visible = true
		ESTADO.ALIMENTACION:
			$Imagen/Alimento.visible = true
			$Imagen/Alimento.frame = 1
			$TimEstado.start(randf_range(3, 6))
		ESTADO.SEGUIR:
			if ext_info == null:
				set_estado(ESTADO.LIBRE)
			else:
				objetivo = ext_info

func est_libre() -> void:
	errar()
	if $TimEstado.is_stopped():
		var p = randf()
		if p < 0.5:
			set_estado(ESTADO.RECOLECCION)
		elif p < 0.7:
			set_estado(ESTADO.CHARLANDO)
		else:
			$TimEstado.start(randf_range(3, 6))

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
		for i in range(1, VISION_MAIZ_MULT):
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
	elif Data.go_estocastico():
		if not objetivo.get_listo():
			objetivo = null

func est_charlando() -> void:
	match Data.seguir_objetivo(self, 100, 75):
		Data.RES_MOVE.NULO:
			set_estado(ESTADO.LIBRE)
			return
		Data.RES_MOVE.LLEGO:
			if not $Imagen/Charlita.visible:
				$Imagen/Charlita.visible = true
				$TimEstado.start(randf_range(3, 6))
		Data.RES_MOVE.FALTA:
			if Data.go_estocastico():
				if objetivo.objetivo != self:
					set_estado(ESTADO.LIBRE)
					return
	if $TimEstado.is_stopped():
		set_estado(ESTADO.LIBRE)

func est_reproduccion() -> void:
	errar()
	if $TimEstado.is_stopped():
		if is_hogar_grupo():
			var aux: Node
			if randf() < 0.75:
				aux = WARRIOR.instantiate()
			else:
				aux = OBRERA.instantiate()
			get_parent().add_child(aux)
			aux.position = position + Vector2(randf() * 10, randf() * 10)
			aux.initialize(get_hogar_grupo(), hogar)
		set_estado(ESTADO.LIBRE)

func est_alimentacion() -> void:
	if $TimEstado.is_stopped():
		$TimEstado.start(randf_range(3, 4))
		if objetivo == null:
			alimentar()
			if estado != ESTADO.REPRODUCCION:
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
			if Data.go_estocastico():
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

func est_seguir() -> void:
	match Data.seguir_objetivo(self, 150, 100):
		Data.RES_MOVE.NULO:
			set_estado(ESTADO.LIBRE)
		Data.RES_MOVE.FALTA:
			if Data.go_estocastico():
				if false: # Tarea ver aliados cercanos u objetivo desinteresado o player
					set_estado(ESTADO.LIBRE)

func _on_tim_errar_timeout() -> void:
	$TimErrar.start(randf_range(1, 7))
	mover_errar = not mover_errar
	huida_giro = randf_range(-PI * 0.25, PI * 0.25)

func hit_proyectil(ind_tech: int) -> void:
	pass
