extends Node
class_name Data

const DEBUG: bool = false

const PROYECTIL = preload("res://Scenes/Objetos/proyectil.tscn")
const EXPLOSIVO = preload("res://Scenes/Objetos/explosivo.tscn")
const VAPOR = preload("res://Scenes/Componentes/vapor.tscn")
const DEATH = preload("res://Scenes/Componentes/death.tscn")

const ESTOCASTICO: float = 0.5 # 0 calculo continuo - 1 extremadamente lento desperdicio loop
const RADIO_CALLE: float = 40 # para detectar cuando llego a una calle
const RETROCESO: float = 400 # velocidad aplicada al empujarlos

# tecnologias: 0:ant 1:imp 2:med 3:ind 4:mod 5:fut
const MUNICION = [10, 1, 20, 12, 200, 300]
const CARGADOR = [10, 1, 20, 1, 10, 20] # municion puesta en mano o arma
const CADENCIA = [3.0, 3.0, 4.0, 1.0, 1.0, 1.0] # tiempo entre disparos
const RECARGAS = [1.0, 1.0, 1.0, 10.0, 5.0, 10.0] # tiempo de recarga
const ESPECIAL = [0, 0, 0, 1, 3, 1] # municion de especial
const AGILIDAD = [2.0, 2.0, 2.0, 2.0, 2.0, 2.0] # tiempo entre golpes mele

enum DIPLOMACIA {
	NORMAL, # los guerreros se distribuyen por todas las casas y algunos exploran
	ATAQUE, # los guerreros se distribuyen por todas las casas y un grupo ataca a un punto
	DEFENSA, # todos los guerreros se hacen en torno a la base propia
	GUERRA, # todos los guerreros van a atacar a un punto, si puntos de bases se cruzan, unificarlos
	EXPLORA # muchos guerreros se ponen en modo exploracion independiente
}

enum RES_MOVE { LLEGO, FALTA, NULO }

enum GRUPO {
	SALVAJE,
	TIGRE, AGUILA, PEZ, TORO, SERPIENTE, INSECTO,
	GRIEGO, EGIPCIO, INDIGENA, AFRICANO, PERSA,
	LATINO, ARABE, VIKINGO, CHINO,
	INGLES, ALEMAN, COLONO,
	GRINGO, RUSO,
	CYBORG,
	SOLO, ANIMAL, ALIEN
}

enum ERA {
	FORMACION,
	PREHISTORIA,
	ANTIGUO,
	IMPERIAL,
	MEDIEVAL,
	INDUSTRIAL,
	MODERNO,
	AVANZADO,
	APOCALIPTICO,
	ETC
}

static func go_estocastico() -> bool:
	return randf() > ESTOCASTICO

# conversiones entre grupos, eras y constantes

static func grupo_to_era(grupo: GRUPO) -> ERA:
	match grupo:
		GRUPO.SALVAJE:
			return ERA.PREHISTORIA
		GRUPO.TIGRE, GRUPO.AGUILA, GRUPO.PEZ, GRUPO.TORO, GRUPO.SERPIENTE, GRUPO.INSECTO:
			return ERA.ANTIGUO
		GRUPO.GRIEGO, GRUPO.EGIPCIO, GRUPO.INDIGENA, GRUPO.AFRICANO, GRUPO.PERSA:
			return ERA.IMPERIAL
		GRUPO.LATINO, GRUPO.ARABE, GRUPO.VIKINGO, GRUPO.CHINO:
			return ERA.MEDIEVAL
		GRUPO.INGLES, GRUPO.ALEMAN, GRUPO.COLONO:
			return ERA.INDUSTRIAL
		GRUPO.GRINGO, GRUPO.RUSO:
			return ERA.MODERNO
		GRUPO.CYBORG:
			return ERA.AVANZADO
	return ERA.ETC

static func era_to_tech(era: ERA) -> int:
	match era:
		ERA.FORMACION, ERA.PREHISTORIA, ERA.ANTIGUO:
			return 0
		ERA.IMPERIAL:
			return 1
		ERA.MEDIEVAL:
			return 2
		ERA.INDUSTRIAL:
			return 3
		ERA.MODERNO:
			return 4
		ERA.AVANZADO, ERA.APOCALIPTICO:
			return 5
	return 0

static func era_to_huevo(era: ERA) -> int:
	match era:
		ERA.FORMACION, ERA.PREHISTORIA, ERA.ANTIGUO:
			return 0
		ERA.IMPERIAL, ERA.MEDIEVAL:
			return 1
		ERA.MODERNO, ERA.INDUSTRIAL:
			return 2
		ERA.AVANZADO, ERA.APOCALIPTICO:
			return 3
	return 0

static func era_to_secundaria(era: ERA) -> Array:
	if era == ERA.INDUSTRIAL:
		return [true, 0]
	elif era == ERA.MODERNO:
		return [true, 1]
	elif era == ERA.AVANZADO or era == ERA.APOCALIPTICO:
		return [true, 2]
	return [false, 0]

static func grupo_to_distancia(grupo: GRUPO) -> Array:
	# distancia, municion_visible, municion
	match grupo:
		GRUPO.SALVAJE,\
		GRUPO.TIGRE, GRUPO.AGUILA, GRUPO.PEZ, GRUPO.TORO, GRUPO.SERPIENTE, GRUPO.INSECTO:
			return [0, true, 1]
		GRUPO.GRIEGO, GRUPO.EGIPCIO, GRUPO.INDIGENA, GRUPO.AFRICANO, GRUPO.PERSA:
			return [2, false, 0]
		GRUPO.LATINO, GRUPO.ARABE, GRUPO.VIKINGO, GRUPO.CHINO:
			return [4, true, 3]
		GRUPO.INGLES, GRUPO.ALEMAN:
			return [5, false, 0]
		GRUPO.COLONO:
			return [6, false, 0]
		GRUPO.GRINGO:
			return [7, false, 0]
		GRUPO.RUSO:
			return [8, false, 0]
		GRUPO.CYBORG:
			return [9, false, 0]
	return [0, false, 0]

static func distancia_to_tech(ind: int) -> int:
	# ind es el frame del arma de distancia, no la municion
	match ind:
		0:
			return 0
		2:
			return 1
		4:
			return 2
		5, 6:
			return 3
		7, 8:
			return 4
		9:
			return 5
	return 0

# informacion de lucha

static func get_damage_mele(tech: int = -1) -> float:
	match tech:
		0: # palo madera
			return 9
		1: # mazo puas
			return 18
		2: # espada hierro
			return 32
		3, 4: # machete
			return 25
		5: # cierra
			return 64
	# mordida
	return 22

static func get_damage_distancia(tech: int = -1) -> float:
	match tech:
		0: # piedra
			return 7
		1: # lanza
			return 50
		2: # flecha
			return 25
		3, 4: # bala
			return 75
		5: # rayo
			return 100
	# explosion
	return 120

static func get_armadura_obrera(tech: int = -1) -> float:
	match tech:
		0: # nude
			return 0.0
		1, 2: # cuero
			return 0.05
		3, 4: # tela
			return 0.1
		5: # carbono
			return 0.4
	# pelaje
	return 0.1

static func get_armadura_mele(tech: int = -1) -> float:
	match tech:
		0: # nude
			return 0.0
		1: # bronce
			return 0.15
		2: # hierro
			return 0.35
		3: # cuero
			return 0.2
		4: # kevlar
			return 0.3
		5: # carbono
			return 0.5
	# pelaje
	return 0.1

static func get_armadura_distancia(tech: int = -1) -> float:
	match tech:
		0: # nude
			return 0.0
		1: # bronce
			return 0.05
		2: # hierro
			return 0.2
		3: # cuero
			return 0.15
		4: # kevlar
			return 0.5
		5: # carbono
			return 0.75
	# pelaje
	return 0.05

static func get_escudo_mele(tech: int = -1) -> float:
	# debe ser < 0.5
	match tech:
		0: # palo madera
			return 0.3
		1: # mazo puas
			return 0.25
		2, 3, 4: # espadas
			return 0.2
		5: # cierra
			return 0.1
	# mordida
	return 0.4

static func get_escudo_distancia(tech: int = -1) -> float:
	# debe ser < 0.5
	match tech:
		0: # piedra
			return 0.4
		1: # lanza
			return 0.2
		2: # flecha
			return 0.3
		3, 4: # bala
			return 0.1
		5: # rayo
			return 0.05
	# explosion
	return 0.0

# funciones de busqueda espacial

static func get_grupo_local(el_parent: Node, grp_name: String) -> Array:
	var cosas = el_parent.get_tree().get_nodes_in_group(grp_name)
	if cosas.is_empty():
		return cosas
	for i in range(cosas.size() - 1, -1, -1):
		if cosas[i].get_parent() != el_parent:
			cosas.remove_at(i)
	return cosas

static func get_nearest(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor: Node = null
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			vision = d
			mejor = ot
	return mejor

static func get_farest(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor: Node = null
	var dismin: float = 0
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d > dismin and d < vision:
			dismin = d
			mejor = ot
	return mejor

static func get_envista(nodo: Node, otros: Array, vision: float = 1000000) -> Array:
	var mundillo = nodo.get_parent()
	var res: Array = []
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			res.append(ot)
	return res

static func get_nearest_vision(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor: Node = null
	var rayo = nodo.get_node("RayEntes")
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			rayo.target_position = ot.global_position - nodo.global_position
			rayo.force_raycast_update()
			if not rayo.is_colliding():
				vision = d
				mejor = ot
	return mejor

static func get_farest_vision(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor: Node = null
	var dismin: float = 0
	var rayo = nodo.get_node("RayEntes")
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d > dismin and d < vision:
			rayo.target_position = ot.global_position - nodo.global_position
			rayo.force_raycast_update()
			if not rayo.is_colliding():
				dismin = d
				mejor = ot
	return mejor

static func get_envista_vision(nodo: Node, otros: Array, vision: float = 1000000) -> Array:
	var mundillo = nodo.get_parent()
	var res: Array = []
	var rayo = nodo.get_node("RayEntes")
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			rayo.target_position = ot.global_position - nodo.global_position
			rayo.force_raycast_update()
			if not rayo.is_colliding():
				res.append(ot)
	return res

static func get_nearest_enemy(nodo: Node, otros: Array, vision: float = 1000000,
		test_hogar_grupo: bool = false, is_warrior_vs_warrior: bool = false) -> Node:
	var mundillo = nodo.get_parent()
	var mejor: Node = null
	var rayo = nodo.get_node("RayEntes")
	var hogar_grupo = GRUPO.SOLO
	if test_hogar_grupo:
		hogar_grupo = nodo.get_hogar_grupo()
	var enemy_grupo = GRUPO.SOLO
	if is_warrior_vs_warrior:
		if nodo.is_hogar_grupo():
			enemy_grupo = nodo.get_archienemigo_grupo()
	for ot in otros:
		if ot == nodo:
			continue
		if ot.get_parent() != mundillo:
			continue
		if test_hogar_grupo:
			if ot.get_hogar_grupo() == hogar_grupo:
				continue
		if is_warrior_vs_warrior:
			var atack = enemy_grupo == GRUPO.ALIEN or\
				(enemy_grupo != GRUPO.SOLO and ot.get_hogar_grupo() == enemy_grupo)
			var otengru = ot.get_archienemigo_grupo()
			var def = otengru == GRUPO.ALIEN or (otengru != GRUPO.SOLO and hogar_grupo == otengru)
			if not (atack or def):
				continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			rayo.target_position = ot.global_position - nodo.global_position
			rayo.force_raycast_update()
			if not rayo.is_colliding():
				vision = d
				mejor = ot
	return mejor

static func get_nearest_obreras(nodo: Node, otros: Array, vision: float = 1000000) -> Array:
	var mundillo = nodo.get_parent()
	# [a,b,c,d] a: preferente, b: secundaria, c,d: (t:atack f:conq)
	var mejor: Array = [null, null, false, false]
	var vista: Array = [vision, vision]
	var rayo = nodo.get_node("RayEntes")
	var hogar_grupo = nodo.get_hogar_grupo()
	var mi_decision = nodo.get_decision_clase(true)
	var i: int
	for ot in otros:
		if ot == nodo:
			continue
		if ot.estado == ot.ESTADO.SEGUIR:
			continue
		if ot.get_parent() != mundillo:
			continue
		if ot.get_hogar_grupo() == hogar_grupo:
			continue
		var decision = ot.get_decision_clase(true)
		# devuelve 2 si sobran, 0 si faltan, 1 si esta perfecto
		var dec = false
		if mi_decision == 2 and decision == 2:
			dec = true
		elif not (mi_decision != 2 and decision != 0):
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if dec: # atack prelacion a grupo no autoctono
			i = 1 if ot.is_in_origen() else 0
		else: # conquist prelacion a propia
			i = 0 if ot.get_grupo() == hogar_grupo else 1
		if d < vista[i]:
			rayo.target_position = ot.global_position - nodo.global_position
			rayo.force_raycast_update()
			if not rayo.is_colliding():
				vista[i] = d
				mejor[i] = ot
				mejor[i + 2] = dec
	return mejor

static func get_obrera_casa(hogar: Node, otros: Array) -> Node:
	var bolsa: Array = []
	for ot in otros:
		if ot.hogar == hogar:
			bolsa.append(ot)
	if bolsa.is_empty():
		var hogar_grupo = hogar.get_grupo()
		for ot in otros:
			if ot.get_hogar_grupo() == hogar_grupo:
				bolsa.append(ot)
	if not bolsa.is_empty():
		return bolsa.pick_random()
	return null

# funciones de obtencion de informacion de la era y mundo

static func get_era(nodo: Node) -> ERA:
	var nombre = nodo.get_parent().get_parent().name
	return get_era_from_name(nombre)

static func get_era_from_name(nombre: String) -> ERA:
	match nombre:
		"MundoFormacion":
			return ERA.FORMACION
		"MundoPrehistoria":
			return ERA.PREHISTORIA
		"MundoAntiguo":
			return ERA.ANTIGUO
		"MundoImperial":
			return ERA.IMPERIAL
		"MundoMedieval":
			return ERA.MEDIEVAL
		"MundoIndustrial":
			return ERA.INDUSTRIAL
		"MundoModerno":
			return ERA.MODERNO
		"MundoAvanzado":
			return ERA.AVANZADO
		"MundoApocaliptico":
			return ERA.APOCALIPTICO
	return ERA.ETC

static func get_next_mundo(nodo: Node, mundos: Array) -> String:
	var era = get_era(nodo)
	if era == ERA.APOCALIPTICO:
		return ""
	for mun in mundos:
		if get_era_from_name(mun.name) == era + 1:
			return mun.name
	return ""

static func get_prev_mundo(nodo: Node, mundos: Array) -> String:
	var era = get_era(nodo)
	if era == ERA.FORMACION:
		return ""
	for mun in mundos:
		if get_era_from_name(mun.name) == era - 1:
			return mun.name
	return ""

# movimiento inteligente de entes

static func huir_de_punto(nodo: Node, meta: Vector2, is_giro_loco: bool = true) -> void:
	var dir = meta.direction_to(nodo.global_position)
	if is_giro_loco:
		dir = dir.rotated(nodo.huida_giro)
	nodo.velocity = dir * nodo.SPEED

static func mover_hacia_punto(nodo: Node, meta: Vector2, radio: float,
		is_giro_loco: bool = true) -> RES_MOVE:
	# comportamiento estocastico para no consumir tantos ciclos de main loop
	if not go_estocastico():
		return RES_MOVE.FALTA
	# en caso de no existir una proxima calle a la cual ir, ira al objetivo directamente
	if nodo.next_calle == null:
		# moverse hacia el objetivo
		nodo.velocity = nodo.global_position.direction_to(meta) * nodo.SPEED
		if is_giro_loco:
			nodo.velocity = nodo.velocity.rotated(nodo.huida_giro)
		# verificar si llego al objetivo
		if nodo.global_position.distance_to(meta) < radio:
			return RES_MOVE.LLEGO
		# cada tanto verificar si el camino directo al objetivo esta libre
		if go_estocastico():
			var rayo = nodo.get_node("RayCalles")
			if Data.is_colision_orillas(nodo.global_position, rayo, meta):
				# como no esta libre, buscar calles para llegar hasta el objetivo
				var mundo = nodo.get_parent().get_parent()
				nodo.obj_calle = Data.get_near_calle(mundo, meta, rayo)
				nodo.next_calle = Data.get_near_calle(mundo, nodo.global_position, rayo)
	# como existe una calle a la cual ir
	else:
		nodo.velocity = nodo.global_position.direction_to(
			nodo.next_calle.global_position) * nodo.SPEED
		if is_giro_loco:
			nodo.velocity = nodo.velocity.rotated(nodo.huida_giro)
		# verificar si llego a la proxima calle
		if nodo.global_position.distance_to(nodo.next_calle.global_position) < RADIO_CALLE:
			# entonces buscar la siguiente
			nodo.next_calle = nodo.next_calle.get_next_calle(nodo.obj_calle)
		# cada tanto tratar de ver si puede llegar sin calle
		if go_estocastico():
			var rayo = nodo.get_node("RayCalles")
			if not Data.is_colision_orillas(nodo.global_position, rayo, meta):
				nodo.next_calle = null
	return RES_MOVE.FALTA

static func mover_hacia_objetivo(nodo: Node, radio: float) -> RES_MOVE:
	# verificacion de la existencia del objetivo, sino retornara nulo
	if is_instance_valid(nodo.objetivo):
		return mover_hacia_punto(nodo, nodo.objetivo.global_position, radio)
	nodo.objetivo = null
	return RES_MOVE.NULO

static func seguir_punto(nodo: Node, meta: Vector2, radio_max: float, radio_min: float) -> RES_MOVE:
	var dis = nodo.global_position.distance_to(meta)
	if dis <= radio_max and dis >= radio_min:
		nodo.velocity = Vector2(0, 0)
		return RES_MOVE.LLEGO
	elif dis > radio_max:
		mover_hacia_punto(nodo, meta, 0)
	else:
		huir_de_punto(nodo, meta, false)
	return RES_MOVE.FALTA

static func seguir_objetivo(nodo: Node, radio_max: float, radio_min: float) -> RES_MOVE:
	# verificacion de la existencia del objetivo, sino retornara nulo
	if is_instance_valid(nodo.objetivo):
		return seguir_punto(nodo, nodo.objetivo.global_position, radio_max, radio_min)
	nodo.objetivo = null
	return RES_MOVE.NULO

static func is_colision_orillas(inicio: Vector2, rayo: RayCast2D, fin: Vector2) -> bool:
	rayo.global_position = inicio
	rayo.target_position = fin - inicio
	rayo.force_raycast_update()
	var res: bool = rayo.is_colliding()
	rayo.position = Vector2(0, 0)
	return res

static func get_near_calle(mundo: Node, inicio: Vector2, rayo: RayCast2D) -> Node:
	var calles = mundo.get_node("Limites/Navegacion").get_children()
	var vision: float = 1000000
	var mejor: Node = null
	for cll in calles:
		if not Data.is_colision_orillas(inicio, rayo, cll.global_position):
			var d = cll.global_position.distance_to(inicio)
			if d < vision:
				vision = d
				mejor = cll
	return mejor

static func is_punto_free(nodo: Node, punto: Vector2, solidos: Array,
		inicio: Vector2 = Vector2(0, 0)) -> bool:
	var rayo = nodo.get_node("RayCalles")
	if inicio.is_zero_approx():
		inicio = nodo.global_position
	if Data.is_colision_orillas(inicio, rayo, punto):
		return false
	for sol in solidos:
		if punto.distance_to(sol.global_position) < sol.get_node("Coli").shape.radius:
			return false
	return true

# crear cosas

static func crea_death(nodo: Node, deaths: Array = []) -> Node:
	var new_parent = nodo.get_parent()
	var pos = nodo.global_position
	for pry in deaths:
		if not pry.visible:
			pry.initialize(new_parent, nodo.get_node("Imagen"), nodo.is_obrera, pos, nodo.is_player)
			return pry
	var pry = DEATH.instantiate()
	new_parent.add_child(pry)
	pry.initialize(new_parent, nodo.get_node("Imagen"), nodo.is_obrera, pos)
	return pry

static func crea_proyectil(nodo: Node, direccion: Vector2, tech: int,
		proyectiles: Array = []) -> Node:
	var new_parent = nodo.get_parent()
	var pos = nodo.global_position + direccion * 40.0
	for pry in proyectiles:
		if not pry.visible:
			pry.initialize(new_parent, nodo.get_hogar_grupo(), direccion, tech, pos)
			return pry
	var pry = PROYECTIL.instantiate()
	new_parent.add_child(pry)
	pry.initialize(new_parent, nodo.get_hogar_grupo(), direccion, tech, pos)
	return pry

static func crea_explosivo(nodo: Node, trayecto: Vector2, is_granada: bool,
		explosivos: Array = []) -> Node:
	var new_parent = nodo.get_parent()
	var pos = nodo.global_position + trayecto.normalized() * 40.0
	for pry in explosivos:
		if not pry.visible:
			pry.initialize(new_parent, nodo.get_hogar_grupo(), trayecto, is_granada, pos)
			return pry
	var pry = EXPLOSIVO.instantiate()
	new_parent.add_child(pry)
	pry.initialize(new_parent, nodo.get_hogar_grupo(), trayecto, is_granada, pos)
	return pry

static func crea_vapor(new_parent: Node, posicion: Vector2, tipo: int,
		vapores: Array = []) -> Node:
	# 0:morado, 1:humo, 2:fuego
	for vap in vapores:
		if not vap.visible:
			vap.initialize(new_parent, posicion, tipo)
			return vap
	var vap = VAPOR.instantiate()
	new_parent.add_child(vap)
	vap.initialize(new_parent, posicion, tipo)
	return vap

static func crea_hongovapor(new_parent: Node, posicion: Vector2, tipo: int,
		radios: int, un_radio: float, vapores: Array = []) -> void:
	# 0:morado, 1:humo, 2:fuego
	crea_vapor(new_parent, posicion, tipo, vapores)
	for r in range(1, radios):
		var desf = randf() * 2.0 * PI
		var rad = un_radio * r
		var perim = 2.0 * PI * rad
		var vaps = ceil(perim / 80.0)
		var paso = 2.0 * PI / vaps
		for i in range(vaps):
			var ang = i * paso + desf + randf_range(-paso * 0.2, paso * 0.2)
			var lon = randf_range(rad * 0.8, rad * 1.2)
			Data.crea_vapor(new_parent, posicion + Vector2(lon, 0).rotated(ang), tipo, vapores)

# informacion textual

static func is_spanish() -> bool:
	return OS.get_locale_language() == "es"

static func get_grupo_name(grp: GRUPO) -> String:
	return GRUPO.keys()[grp]
