extends StaticBody2D

enum DIPLOMACIA {
	NORMAL, # los guerreros se distribuyen por todas las casas y algunos exploran
	ATAQUE, # los guerreros se distribuyen por todas las casas y un grupo ataca a un punto
	DEFENSA, # todos los guerreros se hacen en torno a la base propia
	GUERRA, # todos los guerreros van a atacar a un punto, si puntos de bases se cruzan, unificarlos
	EXPLORA # muchos guerreros se ponen en modo exploracion independiente
}

@export var grupo: Data.GRUPO = Data.GRUPO.SALVAJE

var diplomacia: DIPLOMACIA = DIPLOMACIA.NORMAL
var meta: Node = null # la base o casa a la cual atacar o defender
var estadistica = {
	"casas": 0, # conteo del numero de casas asociadas
	"obreras": 0, # obreras propias
	"capturadas": 0, # obreras venidas de otro grupo del mismo tiempo
	"visitas": 0, # obreras venidas de otro tiempo
	"warriors": 0, # guerreros propios
	"aliados": 0, # guerreros venidos de otro grupo del mismo tiempo
	"refuerzos": 0 # guerreros venidos de otro tiempo
}

func _ready() -> void:
	$Imagen.frame = grupo
	call_deferred("set_casas")

func get_grupo() -> Data.GRUPO:
	return grupo

func set_casas() -> void:
	for cas in get_tree().get_nodes_in_group("casas"):
		if cas.get_grupo() == grupo:
			estadistica["casas"] += 1

func _on_tim_estadisticas_timeout() -> void:
	$TimEstadisticas.start(randf_range(3, 4))
	var era = Data.grupo_to_era(grupo)
	estadistica["obreras"] = 0
	estadistica["capturadas"] = 0
	estadistica["visitas"] = 0
	for ent in get_tree().get_nodes_in_group("obreras"):
		if ent.get_grupo() == grupo:
			estadistica["obreras"] += 1
		elif ent.get_hogar_grupo() == grupo:
			if Data.grupo_to_era(ent.get_grupo()) == era:
				estadistica["capturadas"] += 1
			else:
				estadistica["visitas"] += 1
	estadistica["warriors"] = 0
	estadistica["aliados"] = 0
	estadistica["refuerzos"] = 0
	for ent in get_tree().get_nodes_in_group("warriors"):
		if ent.get_grupo() == grupo:
			estadistica["warriors"] += 1
		elif ent.get_hogar_grupo() == grupo:
			if Data.grupo_to_era(ent.get_grupo()) == era:
				estadistica["aliados"] += 1
			else:
				estadistica["refuerzos"] += 1
