extends Node
class_name Data

enum GRUPO {
	SALVAJE,
	TIGRE, AGUILA, PEZ, TORO, SERPIENTE, INSECTO,
	GRIEGO, EGIPCIO, INDIGENA, AFRICANO, PERSA,
	LATINO, ARABE, VIKINGO, CHINO,
	INGLES, ALEMAN, COLONO,
	GRINGO, RUSO,
	CYBORG
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
	APOCALIPTICO
}

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
	return ERA.APOCALIPTICO

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

# funciones de proposito general

static func get_nearest(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor = null
	for ot in otros:
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d < vision:
			vision = d
			mejor = ot
	return mejor

static func get_farest(nodo: Node, otros: Array, vision: float = 1000000) -> Node:
	var mundillo = nodo.get_parent()
	var mejor = null
	var dismin = 0.0
	for ot in otros:
		if ot.get_parent() != mundillo:
			continue
		var d = ot.global_position.distance_to(nodo.global_position)
		if d > dismin and d < vision:
			dismin = d
			mejor = ot
	return mejor

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
	return -1

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
