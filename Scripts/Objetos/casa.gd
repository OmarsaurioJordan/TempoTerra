extends StaticBody2D

var grupo: Data.GRUPO = Data.GRUPO.SALVAJE
var resi_obreras: Array = []
var resi_warriors: Array = []

func _ready() -> void:
	call_deferred("set_imagen")

func get_grupo() -> Data.GRUPO:
	return grupo

func set_imagen() -> void:
	var bases = get_tree().get_nodes_in_group("bases")
	var near = Data.get_nearest(self, bases)
	grupo = near.get_grupo()
	$Imagen.frame = Data.era_to_tech(Data.grupo_to_era(grupo))

func _on_tim_residentes_timeout() -> void:
	$TimResidentes.start(randf_range(3, 4))
	var obreras = get_tree().get_nodes_in_group("obreras")
	resi_obreras = []
	var aux: Array = [[], []] # originales, visitas
	for ob in obreras:
		if ob.hogar == self:
			if ob.get_grupo() == grupo:
				aux[0].append(ob)
			else:
				aux[1].append(ob)
	resi_obreras.append_array(aux[0])
	resi_obreras.append_array(aux[1])
	var warriors = get_tree().get_nodes_in_group("warriors")
	resi_warriors = []
	aux = [[], []] # originales, visitas
	for ob in warriors:
		if ob.hogar == self:
			if ob.get_grupo() == grupo:
				aux[0].append(ob)
			else:
				aux[1].append(ob)
	resi_warriors.append_array(aux[0])
	resi_warriors.append_array(aux[1])

func get_postura(nodo: Node, is_obrera: bool = false) -> int:
	if is_obrera:
		return resi_obreras.find(nodo)
	return resi_warriors.find(nodo)
