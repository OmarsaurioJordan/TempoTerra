extends StaticBody2D

@export var grupo: Data.GRUPO = Data.GRUPO.SOLO

@onready var diplomacia: Data.DIPLOMACIA = Data.DIPLOMACIA.NORMAL

var mision: Node = null # la base, calle o casa a la cual atacar o defender
var enemy_base: Node = null # solo para marcar base enemiga en modo guerra
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
	$Charla.visible = true
	$Imagen.frame = grupo

func get_grupo() -> Data.GRUPO:
	return grupo

func get_mision() -> Node:
	return mision

func get_archienemigos() -> Data.GRUPO:
	if enemy_base == null:
		return Data.GRUPO.ALIEN
	return enemy_base.get_grupo()

func get_diplomacia() -> Data.DIPLOMACIA:
	return diplomacia

func _on_tim_estadisticas_timeout() -> void:
	$TimEstadisticas.start(randf_range(3, 4))
	estadistica["casas"] = 0
	for cas in get_tree().get_nodes_in_group("casas"):
		if cas.get_grupo() == grupo:
			estadistica["casas"] += 1
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
	# para debug
	$Charla/Texto.text = get_info()

func get_info() -> String:
	var t = "INFO (" + str(int(position.x)) + "," + str(int(position.y)) + ")\nmision: "
	if mision == null:
		t += "null"
	else:
		t += str(int(mision.position.x)) + "," + str(int(mision.position.y))
	t += "\nenemy_base: "
	if enemy_base == null:
		t += "null"
	else:
		t += str(int(enemy_base.position.x)) + "," + str(int(enemy_base.position.y))
	t += "\ncasas: " + str(estadistica["casas"])
	t += " - diplomacia: " + str(diplomacia)
	t += "\nobreras: " + str(estadistica["obreras"] +\
		estadistica["capturadas"] + estadistica["visitas"])
	t += " - warriors: " + str(estadistica["warriors"] +\
		estadistica["aliados"] + estadistica["refuerzos"])
	return t

func set_diplomacia(new_orden: Data.DIPLOMACIA, force_mision: Node = null,
		force_enemy_base: Node = null) -> void:
	if new_orden == diplomacia:
		if force_mision != null and mision != force_mision:
			mision = force_mision
			enemy_base = force_enemy_base
			reset_warriors()
		return
	diplomacia = new_orden
	enemy_base = null
	match diplomacia:
		Data.DIPLOMACIA.NORMAL, Data.DIPLOMACIA.ATAQUE, Data.DIPLOMACIA.EXPLORA:
			mision = null
		Data.DIPLOMACIA.DEFENSA:
			mision = self
		Data.DIPLOMACIA.GUERRA:
			if force_mision != null:
				mision = force_mision
				enemy_base = force_enemy_base
			else:
				var edif = get_tree().get_nodes_in_group("bases")
				edif.erase(self)
				if edif.is_empty():
					set_diplomacia(Data.DIPLOMACIA.NORMAL)
				else:
					mision = edif.pick_random()
					enemy_base = mision
	reset_warriors()

func reset_warriors() -> void:
	var warriors = get_tree().get_nodes_in_group("warriors")
	for wa in warriors:
		wa.base_cambia_diplomacia(self)

func con_obreras() -> bool:
	return estadistica["obreras"] + estadistica["capturadas"] + estadistica["visitas"] > 0

func get_fuerza() -> float:
	var tot = estadistica["warriors"] + estadistica["aliados"] + estadistica["refuerzos"]
	return tot / float(max(1, estadistica["casas"] * 3))

func _on_tim_automatic_timeout() -> void:
	$TimAutomatic.start(randf_range(60, 120))
	var fuerza = get_fuerza()
	# obtener informacion de quien ataca
	var bases = get_tree().get_nodes_in_group("bases")
	bases.erase(self)
	var meatakan = []
	for ba in bases:
		if ba.get_diplomacia() == Data.DIPLOMACIA.GUERRA and ba.enemy_base == self:
			meatakan.append(ba)
	# en caso de no estar siendo atacado, atacar solo si tiene fuerza
	if meatakan.is_empty():
		if diplomacia == Data.DIPLOMACIA.GUERRA:
			var otro_debil = false
			if enemy_base != null:
				if con_obreras():
					otro_debil = enemy_base.get_fuerza() < 0.2
				elif not enemy_base.con_obreras():
					otro_debil = true
			if (fuerza < 0.6 and con_obreras()) or otro_debil:
				set_diplomacia(Data.DIPLOMACIA.NORMAL)
		elif diplomacia == Data.DIPLOMACIA.ATAQUE:
			if fuerza < 0.7 and con_obreras():
				set_diplomacia(Data.DIPLOMACIA.NORMAL)
		else:
			var rnd = [Data.DIPLOMACIA.NORMAL, Data.DIPLOMACIA.EXPLORA, diplomacia]
			if fuerza >= 1 or not con_obreras():
				rnd = [Data.DIPLOMACIA.GUERRA, Data.DIPLOMACIA.ATAQUE, diplomacia]
			set_diplomacia(rnd.pick_random())
	elif (meatakan.size() > 1 or fuerza < 0.6) and con_obreras():
		set_diplomacia(Data.DIPLOMACIA.DEFENSA)
	else:
		set_diplomacia(Data.DIPLOMACIA.GUERRA, meatakan[0])

func _on_tim_zona_timeout() -> void:
	$TimZona.start(randf_range(5, 10))
	# verifica que dos bases en guerra mutua elijan un lugar para pelear, sino que se crucen
	if diplomacia == Data.DIPLOMACIA.GUERRA:
		var bases = get_tree().get_nodes_in_group("bases")
		bases.erase(self)
		var meatakan = []
		for ba in bases:
			if ba.get_diplomacia() == Data.DIPLOMACIA.GUERRA and ba.enemy_base == self and\
					enemy_base == ba:
				meatakan.append(ba)
		if not meatakan.is_empty():
			# la enemistad es mutua, verificar que existe zona de encuentro
			if mision != meatakan[0].get_mision():
				var calles = get_parent().get_parent().get_node("Limites/Navegacion").get_children()
				for i in range(calles.size() - 1, -1, -1):
					if not calles[i].is_guerra():
						calles.remove_at(i)
				mision = calles.pick_random()
				meatakan[0].mision = mision
				reset_warriors()
				meatakan[0].reset_warriors()
		elif mision != enemy_base:
			# forzar que la base atacada sea atacada, no que una anterior calle lo sea
			set_diplomacia(Data.DIPLOMACIA.GUERRA, enemy_base, enemy_base)
