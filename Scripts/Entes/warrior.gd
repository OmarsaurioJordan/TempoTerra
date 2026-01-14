extends Ente

const VIDA: int = 150 # cantidad de puntos de impacto
const SPEED: float = 150 # velocidad de desplazamiento
const ALIMENTO: int = 20 # en cuanto aumenta su vida al ser alimentado
const VISION: float = 1000 # rango de vision para otros entes o cosas

# metodos generales

func initialize(el_grupo: Data.GRUPO, casa: Node) -> void:
	vida = VIDA
	grupo = el_grupo
	hogar = casa
	$Imagen.initialize_warrior(grupo)
	set_estado(ESTADO.LIBRE)

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)

func is_alimentable() -> bool:
	return vida < VIDA

func _physics_process(_delta: float) -> void:
	var bueno_dale = true
	if enemigo != null:
		if is_instance_valid(enemigo):
			seguimiento = enemigo.global_position
			match estado:
				ESTADO.LIBRE, ESTADO.EXPLORAR, ESTADO.MISION:
					bueno_dale = false
					est_bailewar(is_mele(), VISION, SPEED)
				ESTADO.RECARGAR:
					bueno_dale = false
					est_recargar()
					var dir = velocity.normalized() +\
						enemigo.global_position.direction_to(global_position).rotated(huida_giro)
					velocity = dir.normalized() * SPEED
		else:
			enemigo = null
	if bueno_dale:
		if not seguimiento.is_zero_approx():
			match estado:
				ESTADO.LIBRE, ESTADO.EXPLORAR, ESTADO.MISION:
					bueno_dale = false
					if Data.mover_hacia_punto(self, seguimiento, 80, true) == Data.RES_MOVE.LLEGO:
						seguimiento = Vector2(0, 0)
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
	# hacer movimiento aplicando retroceso por golpes
	move_empuje()
	# atacar al enemigo si existe en mira
	atacar()

func set_estado(new_estado: ESTADO, ext_info=null) -> void:
	estado = new_estado
	archienemigos = Data.GRUPO.SOLO
	reset_cosas()
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
						archienemigos = Data.GRUPO.ALIEN
					else:
						mision = edif.pick_random()
						archienemigos = mision.get_grupo()
				else:
					archienemigos = base.get_archienemigos()

# estados

func est_libre() -> void:
	errar(VISION)
	if $TimEstado.is_stopped():
		var base = get_base()
		if base != null:
			var pos = POSTURA.SOBRA
			if base.con_obreras():
				pos = get_postura()
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
		errar(VISION)

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

# acciones de lucha

func atacar() -> void:
	# funcion llamada solo si enemigo ha sido verificado
	# verificar que existe alguien a quien atacar
	if enemigo == null or not $Shots/TimShotGo.is_stopped():
		return
	# verificar si lo alcanza a ver
	if Data.go_estocastico():
		if enemigo.global_position.distance_to(global_position) > VISION:
			enemigo = null
			return
		$RayEntes.target_position = enemigo.global_position - global_position
		$RayEntes.force_raycast_update()
		if $RayEntes.is_colliding():
			enemigo = null
			return
	# hacer el intento de ataque principal
	if is_mele():
		golpear(enemigo)
	else:
		disparar(enemigo.global_position)

# busqueda de objetivos enemigos

func ver_enemigo() -> void:
	# aliens, monstruos, warriors+players, drons, robots, obreras
	if not enemigo_de_grupo("aliens", false, false):
		if not enemigo_de_grupo("monstruos", false, false):
			if not enemigo_de_grupo("warrioplayers", true, true):
				if not enemigo_de_grupo("drones", true, false):
					if not enemigo_de_grupo("robots", true, false):
						enemigo_de_grupo("obreras", true, false) # Tarea obrera es caso especial

func enemigo_de_grupo(grupo_str: String, test_hogar_grupo: bool,
		is_warrior_vs_warrior: bool) -> bool:
	var entes = get_tree().get_nodes_in_group(grupo_str)
	var visto = Data.get_nearest_enemy(self, entes, VISION, test_hogar_grupo, is_warrior_vs_warrior)
	if visto != null:
		enemigo = visto
		return true
	return false

func _on_tim_ver_timeout() -> void:
	$TimVer.start(randf_range(2, 4))
	ver_enemigo()

# metodo especialmente para warrior, para hacer cambios masivos

func base_cambia_diplomacia(base: Node) -> void:
	if base == get_base():
		set_estado(ESTADO.LIBRE)
