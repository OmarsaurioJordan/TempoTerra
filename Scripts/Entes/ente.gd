extends CharacterBody2D
class_name Ente

const DIST_SEGUIR_PLAYER: float = 700

enum POSTURA { HOGAR, EXTRA, SOBRA, VIEJO }

enum ESTADO {
	LIBRE, SEGUIR, # general
	CHARLANDO, REPRODUCCION, RECOLECCION, ALIMENTACION, # obrera
	EXPLORAR, CONQUISTAR, RECARGAR, MISION # warrior
}
var estado: ESTADO = ESTADO.LIBRE

# fundamentales para existir
var vida: float

# para agrupamiento
var grupo: Data.GRUPO = Data.GRUPO.SOLO # pertenencia original segun vestimenta
var hogar: Node = null # casa, pertenencia ideologia o a donde se ha unido
var is_obrera: bool = false

# para navegacion y automata
var meta: Vector2 = Vector2(0, 0) # punto al que se desea llegar
var objetivo: Node = null # nodo al que se desea llegar
var next_calle: Node = null # proxima calle para llegar a la final
var obj_calle: Node = null # calle final que conecta con objetivo
var mover_errar: bool = false # para saber si esta en ciclo de movimiento
var huida_giro: float = 0 # para esquivar al huir

# para luchas y golpes
var municion: int = 0
var cargador: int = 0 # municion actualmente en el arma
var especial: int = 0 # municion especial
var mision: Node = null # la base, calle o casa a la cual atacar o defender
var archienemigos: Data.GRUPO = Data.GRUPO.SOLO # la mision a que grupo enemigo apunta
var enemigo: Node = null # a quien tiene en mira para atacar
var seguimiento: Vector2 = Vector2(0, 0) # ultima vez que vio a enemigo
var dir_baile_rebote: Vector2 = Vector2(0, 0) # para moverse en la zona de pelea
var cuerpos_golpeables: Array = [] # cuerpos en mira del area de mele
var retroceso: Vector2 = Vector2(0, 0) # empujar cuando recibe golpes
var prepunteria: Vector2 = Vector2(0, 0) # posicion de enemigo para disparo pre establecido
var is_player: bool = false # para poder manejar cosas manualmente
var lanzo_explosivo: int = 0 # 0:ninguno, 1:fuego, 2:granada

# para optimizacion
var parent_mundo: Node = null

# para obtener informacion general

func is_libre() -> bool:
	return estado == ESTADO.LIBRE

func get_hogar() -> Node:
	return hogar

func is_in_origen() -> bool:
	if hogar != null:
		return hogar.grupo == grupo
	return false

func get_hogar_grupo() -> Data.GRUPO:
	if hogar != null:
		return hogar.grupo
	return Data.GRUPO.SOLO

func is_hogar_grupo() -> bool:
	return get_hogar_grupo() != Data.GRUPO.SOLO

func get_grupo() -> Data.GRUPO:
	return grupo

func get_postura() -> POSTURA:
	if hogar != null:
		var i = hogar.get_postura(self, is_obrera)
		if i <= 0:
			return POSTURA.HOGAR
		elif i == 1:
			return POSTURA.EXTRA
		elif i == 2:
			return POSTURA.SOBRA
		return POSTURA.VIEJO
	return POSTURA.HOGAR

func get_base() -> Node:
	if is_hogar_grupo():
		var bases = get_tree().get_nodes_in_group("bases")
		var hogar_grupo = get_hogar_grupo()
		for b in bases:
			if b.get_grupo() == hogar_grupo:
				return b
	return null

func get_decision_clase(is_find_obreras: bool) -> int:
	# devuelve 2 si sobran, 0 si faltan, 1 si esta perfecto
	var base = get_base()
	if base != null:
		return base.get_decision_clase(is_find_obreras)
	return 0

# para movimientos

func errar(vision: float) -> void:
	if mover_errar:
		if meta.is_zero_approx():
			var solidos = Data.get_grupo_local(get_parent(), "buildings")
			var pp = global_position + Vector2(randf() * vision, 0).rotated(randf() * 2 * PI)
			if is_hogar_grupo():
				var mis_edif = []
				var mi_grupo = get_hogar_grupo()
				for sol in solidos:
					if sol.get_grupo() == mi_grupo:
						mis_edif.append(sol)
				if not mis_edif.is_empty():
					pp = mis_edif.pick_random().global_position +\
						Vector2(randf() * vision, 0).rotated(randf() * 2 * PI)
			if Data.is_punto_free(self, pp, solidos):
				meta = pp
		elif Data.mover_hacia_punto(self, meta, 75) == Data.RES_MOVE.LLEGO:
			# llego al punto dado
			meta = Vector2(0, 0)
	else:
		velocity = Vector2(0, 0)

func move_empuje() -> void:
	if retroceso.length() > 10:
		retroceso *= 0.95
		var ant = velocity
		velocity += retroceso
		move_and_slide()
		velocity = ant
	else:
		move_and_slide()

func _on_tim_errar_timeout() -> void:
	$TimErrar.start(randf_range(1, 7))
	mover_errar = not mover_errar
	huida_giro = randf_range(-PI * 0.25, PI * 0.25)
	parent_mundo = get_parent().get_parent()

# para ser golpeado

func hit_proyectil(ind_tech: int, dir_empuje: Vector2) -> void:
	retroceso = dir_empuje * Data.RETROCESO * 0.5
	var damage = Data.get_damage_distancia(ind_tech)
	var arm_esc = get_armor_escudo(ind_tech, false)
	if randf() > arm_esc[1]:
		vida -= damage * (1.0 - arm_esc[0])
		post_hit()
	else:
		$Imagen/AniEscudo.play("escudo")

func hit_mele(ind_tech: int, dir_empuje: Vector2) -> void:
	retroceso = dir_empuje * Data.RETROCESO
	var damage = Data.get_damage_mele(ind_tech)
	var arm_esc = get_armor_escudo(ind_tech, true)
	if randf() > arm_esc[1]:
		vida -= damage * (1.0 - arm_esc[0])
		post_hit()
	else:
		$Imagen/AniEscudo.play("escudo")

func hit_explosion(is_granada: bool, dir_empuje: Vector2) -> void:
	retroceso = dir_empuje * Data.RETROCESO * 0.75
	var damage = Data.get_damage_distancia()
	if not is_granada:
		damage *= 0.5
	var arm_esc = get_armor_escudo(-1, false)
	if randf() > arm_esc[1]:
		vida -= damage * (1.0 - arm_esc[0])
		post_hit()
	else:
		$Imagen/AniEscudo.play("escudo")

func get_armor_escudo(ind_tech: int, is_for_mele: bool) -> Array:
	var my_tech = Data.era_to_tech(Data.grupo_to_era(grupo))
	var armadura: float = 0
	var escudo: float = get_escudo()
	if is_obrera:
		armadura = Data.get_armadura_obrera(my_tech)
	elif is_for_mele:
		armadura = Data.get_armadura_mele(my_tech)
		escudo *= Data.get_escudo_mele(ind_tech)
	else:
		armadura = Data.get_armadura_distancia(my_tech)
		escudo *= Data.get_escudo_distancia(ind_tech)
	return [armadura, escudo]

func post_hit() -> void:
	$Imagen/AniHit.play("hit")
	if estado == ESTADO.CONQUISTAR:
		objetivo = null
	if vida <= 0:
		death()

func death() -> void:
	# Tarea limpiar enemigo y seguimiento en todos
	if is_player:
		var entes = get_tree().get_nodes_in_group("entes")
		for ent in entes:
			if ent == self:
				continue
			ent.set_envisto(false)
			ent.set_seleccionado(false)
		return # Tarea activar respawn player
	var deaths = get_tree().get_nodes_in_group("deaths")
	Data.crea_death(self, deaths)
	queue_free()

# para hacer cambios generales

func reset_cosas() -> void:
	objetivo = null
	next_calle = null
	meta = Vector2(0, 0)
	archienemigos = Data.GRUPO.SOLO
	velocity = Vector2(0, 0)
	$TimEstado.stop()

func _on_tim_reubicar_timeout() -> void:
	$TimReubicar.start(randf_range(10, 15))
	if get_postura() >= POSTURA.SOBRA:
		var casas = Data.get_grupo_local(get_parent(), "casas")
		var hogar_grupo = get_hogar_grupo()
		var posibles = [[], [], []]
		for ca in casas:
			if ca.get_grupo() == hogar_grupo:
				var tot = ca.get_total(is_obrera)
				if tot < 3:
					posibles[tot].append(ca)
		for pos in posibles:
			if not pos.is_empty():
				hogar = pos.pick_random()
				break

func envejecer(el_grupo: Data.GRUPO) -> bool:
	if $TimNoVejez.is_stopped():
		if get_hogar_grupo() == el_grupo:
			if get_postura() == POSTURA.VIEJO:
				death()
				return true
	return false

func evade_ciclo() -> bool:
	if parent_mundo.visible:
		return false
	return randf() < 0.5 # 0 continuo siempre activo, 1 desactivado

func aquietar(segundos: float) -> void:
	$TimPausa.start(segundos)

# obtener informacion de ataque y lucha

func is_mele() -> bool:
	return $Imagen/Arma.visible

func get_dist_tech() -> int:
	return Data.distancia_to_tech($Imagen/Distancia.frame)

func get_archienemigo_grupo() -> Data.GRUPO:
	return archienemigos

func get_escudo(check_if_ready: bool = true) -> int:
	if is_obrera:
		return 0
	if check_if_ready and $Imagen/AniEscudo.is_playing():
		return 0
	if $Imagen/Escudo.visible:
		var fr = $Imagen/Escudo.frame
		if fr >= 7 and fr <= 11:
			return Data.ESCUDO_MULT[0]
		elif fr >= 12 and fr <= 15:
			return Data.ESCUDO_MULT[1]
	return 0

func get_explosivo() -> int:
	# 0:fuego 1:granada 2:control -1:nada
	if especial != 0 and $Imagen/Secundaria.visible:
		return $Imagen/Secundaria.frame
	return -1

# acciones de ataque y lucha

func est_bailewar(is_mele_mode: bool, vision: float, velocidad: float) -> void:
	# funcion llamada solo si enemigo ha sido verificado
	# acercarse a enemigo ya que es mele, pero alejarse un poco si no esta listo el ataque
	if is_mele_mode:
		if not $Shots/TimShotMele.is_stopped() and $Shots/TimShotGo.is_stopped():
			Data.seguir_punto(self, enemigo.global_position, 150, 100)
		else:
			Data.seguir_punto(self, enemigo.global_position, 10, 0)
	# alejarse mientras esta recargando municion
	elif not $Shots/TimShotCargador.is_stopped():
		Data.seguir_punto(self, enemigo.global_position, vision * 0.9, vision * 0.8)
	# alejarse un poco mientras esta en espacio de recarga de tiro, cadencia
	elif not $Shots/TimShotDistance.is_stopped():
		Data.seguir_punto(self, enemigo.global_position, vision * 0.7, vision * 0.5)
	# mantenerse a una distancia media para apuntar bien
	else:
		Data.seguir_punto(self, enemigo.global_position, vision * 0.6, vision * 0.4)
	# en caso de usar rifle antiguo, evalua posibilidades de cambio de arma
	if Data.go_estocastico():
		if get_dist_tech() == 3:
			var dis = global_position.distance_to(enemigo.global_position)
			if is_mele_mode:
				if dis > vision * 0.5 and cargador + municion > 0:
					$Imagen.set_distancia()
			elif dis < vision * 0.3:
				$Imagen.set_mele()
	# para evitar que se quede quieto en la franja permitida
	if velocity.is_zero_approx():
		velocity = dir_baile_rebote * velocidad
	else:
		dir_baile_rebote = Vector2(1, 0).rotated(randf() * 2.0 * PI)

func recargar() -> void:
	var tech = get_dist_tech()
	if cargador < Data.CARGADOR[tech] and municion > 0 and $Shots/TimShotCargador.is_stopped():
		$Shots/TimShotCargador.start(Data.RECARGAS[tech])
		$Imagen/AniShot.play("recharge")

func disparar(lugar: Vector2) -> void:
	if municion + cargador > 0 and $Shots/TimShotGo.is_stopped():
		if cargador == 0:
			recargar()
		elif $Shots/TimShotDistance.is_stopped() and $Shots/TimShotCargador.is_stopped():
			disparar_forzado(lugar)

func disparar_forzado(lugar: Vector2) -> void:
	# forzado porque no verifica si los temporizadores estan listos o si hay municion
	$Shots/TimShotGo.start()
	$Shots/TimShotDistance.start(Data.CADENCIA[get_dist_tech()])
	$Imagen/AniShot.play("shot")
	$TimPausa.start(0.5)
	lanzo_explosivo = 0
	prepunteria = lugar
	cargador -= 1

func lanza_explosivo(lugar: Vector2) -> void:
	var explo = get_explosivo()
	if $Shots/TimShotEspecial.is_stopped() and explo in [0, 1]:
		$Shots/TimShotGo.start()
		$Shots/TimShotEspecial.start(3)
		$Imagen/AniEspecial.play("lanza")
		$TimPausa.start(1)
		lanzo_explosivo = explo + 1
		prepunteria = lugar
		especial -= 1

func golpear(nodo_enemy: Node = null) -> void:
	if $Shots/TimShotMele.is_stopped() and $Shots/TimShotGo.is_stopped():
		if nodo_enemy == null:
			$Shots/TimShotGo.start()
			$Shots/TimShotMele.start(Data.AGILIDAD[get_dist_tech()])
			$Imagen/AniShot.play("hit")
			lanzo_explosivo = 0
			return
		for bdy in cuerpos_golpeables:
			if bdy == nodo_enemy:
				$Shots/TimShotGo.start()
				$Shots/TimShotMele.start(Data.AGILIDAD[get_dist_tech()])
				$Imagen/AniShot.play("hit")
				lanzo_explosivo = 0
				break

# ejecuciones automaticas de ataque y lucha

func _on_ataque_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if not body in cuerpos_golpeables:
		cuerpos_golpeables.append(body)

func _on_ataque_body_exited(body: Node2D) -> void:
	cuerpos_golpeables.erase(body)

func _on_tim_shot_go_timeout() -> void:
	if is_mele():
		if is_player:
			pass # tarea elegir un enemigo digno segun mouse
		else:
			for bdy in cuerpos_golpeables:
				if bdy == enemigo:
					bdy.hit_mele(Data.distancia_to_tech($Imagen/Distancia.frame),
						global_position.direction_to(bdy.global_position))
					break
	elif lanzo_explosivo != 0:
		var explosivos = get_tree().get_nodes_in_group("explosivos")
		var trayecto = prepunteria - global_position
		if is_player:
			trayecto = get_global_mouse_position() - global_position
		Data.crea_explosivo(self, trayecto, lanzo_explosivo == 2, explosivos)
	else:
		var proyectiles = get_tree().get_nodes_in_group("proyectiles")
		var dir = global_position.direction_to(prepunteria) # Tarea agregar azar
		if is_player:
			dir = global_position.direction_to(get_global_mouse_position())
		Data.crea_proyectil(self, dir, get_dist_tech(), proyectiles)

func _on_tim_shot_cargador_timeout() -> void:
	var tech = get_dist_tech()
	while cargador < Data.CARGADOR[tech] and municion > 0:
		cargador += 1
		municion -= 1
	$Imagen/AniShot.play("RESET")
	if municion + cargador <= 1:
		$Imagen/Municion.visible = false

func _on_ani_shot_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"shot":
			if cargador == 0 and municion > 0:
				recargar()
			elif municion + cargador == 0 and $Imagen/Distancia.frame != 4: # arco
				$Imagen.set_mele()

func _on_ani_especial_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"lanza":
			if not get_explosivo() in [0, 1]:
				$Imagen/Secundaria.visible = false

# seleccion

func set_envisto(is_envisto: bool) -> void:
	$Enmira.visible = is_envisto

func get_envisto() -> bool:
	return $Enmira.visible

func set_seleccionado(is_seleccionado: bool) -> void:
	$Select.visible = is_seleccionado

func get_seleccionado() -> bool:
	if is_player:
		return false
	return $Select.visible

func set_tiempo(nombre_mundo: String, hongovapor: bool = true) -> void:
	if nombre_mundo != "":
		var mundo = get_parent().get_parent().get_parent().get_node(nombre_mundo)
		var pos = position
		get_parent().remove_child(self)
		mundo.get_node("Objetos").add_child(self)
		position = pos
		if is_player:
			call_deferred("set_camara_mundo")
		else:
			estado = ESTADO.LIBRE
			reset_cosas()
			$TimEstado.start(randf_range(3, 6))
			base_cambiotiempo()
		if hongovapor:
			var vapores = get_tree().get_nodes_in_group("vapores")
			var parent = get_parent()
			if is_player:
				Data.crea_hongovapor(parent, global_position, 0, 3, 64, vapores)
			else:
				Data.crea_hongovapor(parent, global_position, 0, 2, 64, vapores)

func base_cambiotiempo() -> void:
	# esto se ejecuta cuando viaja en el tiempo y tiene que decir a que grupo pertenece
	$TimNoVejez.start()
	var casas = Data.get_grupo_local(get_parent(), "casas")
	casas.shuffle()
	for cas in casas:
		if cas.get_grupo() == grupo:
			hogar = cas
			return
	hogar = null

func no_seleccionado(el_player: Node) -> void:
	# funcion ejecutada cuando se quiera verificar si conserva el estado seleccionado
	if $Select.visible:
		if el_player.global_position.distance_to(global_position) > DIST_SEGUIR_PLAYER:
			$Select.visible = false

# informacion textual

static func get_est_name(est: ESTADO) -> String:
	return ESTADO.keys()[est]
