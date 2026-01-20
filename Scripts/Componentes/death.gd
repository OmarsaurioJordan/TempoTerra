extends Node2D

const TIME_FIN: float = 720
var time_fin: float = 0

func _ready() -> void:
	set_process(false)

func initialize(new_parent: Node, nodo_imagen: Node, is_obrera: bool, posicion: Vector2,
		is_player: bool = false) -> void:
	visible = true
	get_parent().remove_child(self)
	new_parent.add_child(self)
	time_fin = TIME_FIN
	modulate = Color(1, 1, 1, 1)
	global_position = posicion
	set_process(true)
	for pp in [$PieD, $PieI, $Cuerpo, $Cabeza]:
		pp.get_node("Ori").visible = not is_player
		pp.get_node("Ext").visible = is_player
	if not is_player:
		$PieD/Ori.frame = nodo_imagen.get_node("PieD").frame
		$PieI/Ori.frame = nodo_imagen.get_node("PieI").frame
		$Cuerpo/Ori.frame = nodo_imagen.get_node("Cuerpo").frame
		$Cabeza/Ori.frame = nodo_imagen.get_node("Cabeza").frame
	if is_obrera:
		$Escudo.visible = false
		$Municion.visible = false
		$Secundaria.visible = false
		$Arma.visible = false
		$Distancia.visible = false
		# set visibles
		$Bolsa.visible = nodo_imagen.get_node("Bolsa").visible
		$Huevo.visible = nodo_imagen.get_node("Huevo").visible
		$Alimento.visible = nodo_imagen.get_node("Alimento").visible
		# set frames
		$Bolsa.frame = nodo_imagen.get_node("Bolsa").frame
		$Huevo.frame = nodo_imagen.get_node("Huevo").frame
		$Alimento.frame = nodo_imagen.get_node("Alimento").frame
	else:
		$Bolsa.visible = false
		$Huevo.visible = false
		$Alimento.visible = false
		# set visibles
		$Escudo.visible = nodo_imagen.get_node("Escudo").visible
		$Municion.visible = nodo_imagen.get_node("Municion").visible
		$Secundaria.visible = nodo_imagen.get_node("Secundaria").visible
		$Arma.visible = nodo_imagen.get_node("Arma").visible
		$Distancia.visible = nodo_imagen.get_node("Distancia").visible
		# set frames
		$Escudo.frame = nodo_imagen.get_node("Escudo").frame
		$Municion.frame = nodo_imagen.get_node("Municion").frame
		$Secundaria.frame = nodo_imagen.get_node("Secundaria").frame
		$Arma.frame = nodo_imagen.get_node("Arma").frame
		$Distancia.frame = nodo_imagen.get_node("Distancia").frame
	$Anima.play("die")

func _process(delta: float) -> void:
	time_fin -= delta
	if time_fin <= 0:
		visible = false
		set_process(false)
	else:
		modulate = Color(1, 1, 1, time_fin / TIME_FIN)
