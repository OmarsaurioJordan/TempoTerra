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
	var tech = Data.era_to_tech(era)
	set_armas_base(grupo)
	# 0:antiguo 1:imperial 2:medieval 3:industrial 4:moderno 5:avanzado
	if (tech == 0 or tech == 2) and randf() < 0.5:
		set_mele()
	else:
		set_distancia()

func set_armas_base(grupo: Data.GRUPO) -> void:
	# secundaria
	var era = Data.grupo_to_era(grupo)
	var sec = Data.era_to_secundaria(era)
	$Secundaria.visible = sec[0]
	$Secundaria.frame = sec[1]
	# distancia
	var dis = Data.grupo_to_distancia(grupo)
	$Municion.frame = dis[2]
	$Distancia.frame = dis[0]
	# arma mele
	$Escudo.frame = grupo
	$Arma.frame = grupo
	# rellenar
	var nodo = get_parent()
	var tech = nodo.get_dist_tech()
	nodo.municion = Data.MUNICION[tech]
	nodo.cargador = 0
	nodo.especial = Data.ESPECIAL[tech]

func set_mele() -> void:
	# invisibilizar
	$Municion.visible = false
	$Distancia.visible = false
	# arma mele
	$Escudo.visible = $Escudo.frame >= 7 and $Escudo.frame <= 15
	$Arma.visible = true

func set_distancia() -> void:
	# invisibilizar
	$Escudo.visible = $Escudo.frame >= 7 and $Escudo.frame <= 15
	$Arma.visible = false
	# distancia
	$Municion.visible = $Municion.frame == 1 or $Municion.frame == 3
	$Distancia.visible = true
	if $Municion.visible:
		$Escudo.visible = false
	# rellenar
	var nodo = get_parent()
	var tech = nodo.get_dist_tech()
	nodo.get_node("Shots/TimShotCargador").start(Data.RECARGAS[tech])
	$Anima.play("recharge")
