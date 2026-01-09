extends Node2D

@export var name_nodos_respiran: Array[String] = []
@export var amplitud: float = 4.0
@export var ampli_pierna: float = 5.0
@export var veloci_pies: float = 3.0

var inicial_respiran: Array = []
var valores_respiran: Array = []
var nodos_respiran: Array = []
var pies_reloj: float = randf()
var pies_inicial: float = 0.0
var ant_position: Vector2 = Vector2(0, 0)

func _ready() -> void:
	for nn in name_nodos_respiran:
		nodos_respiran.append(get_node(nn))
		inicial_respiran.append(nodos_respiran[-1].position.y)
		valores_respiran.append(randf())
	pies_inicial = get_node("PieI").position.y
	ant_position = global_position

func _process(delta: float) -> void:
	for n in range(nodos_respiran.size()):
		valores_respiran[n] += delta * randf_range(0.9, 1.0)
		if valores_respiran[n] > 1.0:
			valores_respiran[n] -= 1.0
		nodos_respiran[n].position.y = inicial_respiran[n] +\
			amplitud * sin(valores_respiran[n] * 2.0 * PI)
	pies_reloj += delta * randf_range(0.9, 1.0) * veloci_pies
	if pies_reloj > 1.0:
		pies_reloj -= 1.0
	if ant_position.x != global_position.x or ant_position.y != global_position.y:
		ant_position = global_position
		$PieD.position.y = pies_inicial - (1.0 + sin(pies_reloj * 2.0 * PI)) * ampli_pierna
		$PieI.position.y = pies_inicial - (1.0 + sin((1.0 - pies_reloj) * 2.0 * PI)) * ampli_pierna
	else:
		$PieD.position.y = pies_inicial
		$PieI.position.y = pies_inicial

func set_texto(texto: String = "") -> void:
	$Charla.visible = texto != ""
	if $Charla.visible:
		$Charla/Texto.text = texto

func initialize_obrera(grupo: Data.GRUPO) -> void:
	$Cuerpo.frame = grupo * 2 + 1
	$Cabeza.frame = grupo * 2 + 1
	var era = Data.grupo_to_era(grupo)
	$PieD.frame = Data.era_to_tech(era) * 2 + 1
	$PieI.frame = Data.era_to_tech(era) * 2 + 1
	$Bolsa.frame = Data.era_to_tech(era)
	$Huevo.frame = Data.era_to_huevo(era)

func initialize_warrior(grupo: Data.GRUPO) -> void:
	$Cuerpo.frame = grupo * 2
	$Cabeza.frame = grupo * 2
	var era = Data.grupo_to_era(grupo)
	$PieD.frame = Data.era_to_tech(era) * 2
	$PieI.frame = Data.era_to_tech(era) * 2
	set_armas(grupo)

func set_armas(grupo: Data.GRUPO) -> void:
	var era = Data.grupo_to_era(grupo)
	# 0:antiguo 1:imperial 2:medieval 3:industrial 4:moderno 5:avanzado
	if Data.era_to_tech(era) <= 2:
		set_mele(grupo)
	else:
		set_distancia(grupo)

func set_mele(grupo: Data.GRUPO) -> void:
	# invisibilizar
	$Municion.visible = false
	$Distancia.visible = false
	# escudo
	$Escudo.visible = grupo >= Data.GRUPO.GRIEGO and grupo <= Data.GRUPO.CHINO
	$Escudo.frame = grupo
	# secundaria
	var era = Data.grupo_to_era(grupo)
	var sec = Data.era_to_secundaria(era)
	$Secundaria.visible = sec[0]
	$Secundaria.frame = sec[1]
	# arma
	$Arma.visible = true
	$Arma.frame = grupo

func set_distancia(grupo: Data.GRUPO) -> void:
	# invisibilizar
	$Escudo.visible = false
	$Arma.visible = false
	# secundaria
	var era = Data.grupo_to_era(grupo)
	var sec = Data.era_to_secundaria(era)
	$Secundaria.visible = sec[0]
	$Secundaria.frame = sec[1]
	# municion
	var dis = Data.grupo_to_distancia(grupo)
	$Municion.visible = dis[1]
	$Municion.frame = dis[2]
	# distancia
	$Distancia.visible = true
	$Distancia.frame = dis[0]
