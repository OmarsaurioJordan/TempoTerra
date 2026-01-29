extends Ente

const CERCANO: float = 200

const VIDA: float = 200
const SPEED: float = 300
const ALIMENTO: int = 20
const TIME_VIAJE: float = 4
const COMBUSTIBLE: int = 10

@onready var gui: Node = get_tree().get_nodes_in_group("gui")[0]
var area_tab: Array = []
var linea: Line2D = null

var is_al_futuro: bool = true # dice si viaja al futuro o pasado
var is_viaje_ida: bool = true # para saber si particulas aparecen o desaparecen
var reloj_viaje: float = 0 # para ejecutar teleportacion
var combustible: int = 5 # para poder hacer viajes

# metodos generales

func _ready() -> void:
	is_player = true
	vida = VIDA
	$Imagen/Charlita.visible = false
	call_deferred("set_camara_mundo")
	gui.get_node("Informacion").visible = false
	gui.get_node("Datos").visible = false
	gui.get_node("Datas").visible = false
	$PartiUp.visible = false
	$PartiDown.visible = false

func initialize(_grp=0, _csa=null) -> void:
	grupo = Data.GRUPO.CYBORG
	#$Imagen.set_armas(grupo)
	$Imagen.set_armas(Data.GRUPO.GRINGO)

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)

func is_alimentable() -> bool:
	return vida < VIDA

func _physics_process(delta: float) -> void:
	# cambiar de linea temporal
	if Input.is_action_just_pressed("ui_futuro"):
		go_viaje_temp(true)
	elif Input.is_action_just_pressed("ui_pasado"):
		go_viaje_temp(false)
	# moverse por el suelo
	var dir: Vector2 = Input.get_vector("ui_izquierda", "ui_derecha", "ui_arriba", "ui_abajo")
	if dir.length() != 0 and $TimPausa.is_stopped():
		velocity = dir * SPEED
	else:
		velocity = Vector2(0, 0)
	# hacer movimiento aplicando retroceso por golpes
	move_empuje()
	# posicionar el mouse
	for mou in get_tree().get_nodes_in_group("mouses"):
		mou.global_position = get_global_mouse_position()
		if linea != null:
			linea.set_point_position(0, position)
			linea.set_point_position(1, mou.global_position - linea.global_position)
	# interaccion tab
	if Input.is_action_just_pressed("ui_dialogos"):
		if gui.get_node("Informacion").visible:
			gui.get_node("Informacion").visible = false
			Engine.time_scale = gui.get_parent().clock_speed
		elif not area_tab.is_empty():
			gui.get_node("Informacion").visible = true
			Engine.time_scale = 0
			var base = area_tab[0].get_parent()
			if Data.is_spanish():
				gui.get_node("Informacion/Texto").text =\
					gui.get_node("Datos/G" + str(base.get_grupo())).text
			else:
				gui.get_node("Informacion/Texto").text =\
					gui.get_node("Datas/G" + str(base.get_grupo())).text
	# cambiar velocidad de ejecucion
	if Input.is_action_just_pressed("ui_speed"):
		if $TimPausa.is_stopped():
			$TimPausa.start(1.5)
			gui.get_parent().clock_speed = 1 if gui.get_parent().clock_speed != 1 else 2
			if Engine.time_scale != 0:
				Engine.time_scale = gui.get_parent().clock_speed
				var vapores = get_tree().get_nodes_in_group("vapores")
				Data.crea_hongovapor(get_parent(), global_position, 0, 2, 64, vapores)
	# disparar y recargar
	if Input.is_action_pressed("ui_disparo"):
		disparar(get_global_mouse_position())
	elif Input.is_action_pressed("ui_especial"):
		lanza_explosivo(get_global_mouse_position())
	elif Input.is_action_pressed("ui_recarga"):
		recargar()
	# seleccion
	if Input.is_action_just_pressed("ui_seleccionar"):
		seleccionar()
	# particulas viaje tiempo
	if $PartiUp.visible:
		step_particulas(delta)
	# estadisticas en interfaz
	gui.get_node("TxtAmmo").text = str(cargador) + "/" + str(municion) + "\n" + str(especial)
	var cmbst = ""
	for i in range(COMBUSTIBLE):
		cmbst += "-" if i < combustible else "|"
	gui.get_node("TxtVida").text = str(int((vida / VIDA) * 100.0)) + "%\n" + cmbst

# metodos para viajar en el tiempo

func set_camara_mundo() -> void:
	var lim: Node = get_parent().get_parent().get_node("Limites")
	$Camara.limit_left = lim.global_position.x
	$Camara.limit_top = lim.global_position.y
	$Camara.limit_right = lim.get_node("Limite").global_position.x
	$Camara.limit_bottom = lim.get_node("Limite").global_position.y
	$Camara.position = Vector2(0, 0)
	for mou in get_tree().get_nodes_in_group("mouses"):
		mou.get_parent().remove_child(mou)
		get_parent().add_child(mou)
	var mi_mundo = get_parent().get_parent().name
	for mu in get_tree().get_nodes_in_group("mundos"):
		mu.visible = mu.name == mi_mundo
	linea = get_parent().get_parent().get_node("Limites/Lineas/Linea")
	match mi_mundo:
		"MundoFormacion":
			gui.get_node("TxtEra").text = "Ancient\n14 Ma"
		"MundoPrehistoria":
			gui.get_node("TxtEra").text = "Ice Age\n12000 BEC"
		"MundoAntiguo":
			gui.get_node("TxtEra").text = "Tribal\n6000 BEC"
		"MundoImperial":
			gui.get_node("TxtEra").text = "Imperial\n300 BEC"
		"MundoMedieval":
			gui.get_node("TxtEra").text = "Medieval\n1000 CE"
		"MundoIndustrial":
			gui.get_node("TxtEra").text = "Industrial\n1800 CE"
		"MundoModerno":
			gui.get_node("TxtEra").text = "Modern\n2000 CE"
		"MundoAvanzado":
			gui.get_node("TxtEra").text = "Futuristic\n2500 CE"
		"MundoApocaliptico":
			gui.get_node("TxtEra").text = "Apocalyptic\n3000 CE"
	if Data.is_spanish():
		gui.get_node("TxtEra").text = gui.get_node("TxtEra").text.\
			replace("BEC", "AC").replace("CE", "DC")

# automaticos para detecciones especiales

func _on_area_tab_area_entered(area: Area2D) -> void:
	if not area in area_tab:
		area_tab.append(area)
	$Imagen/Charlita.visible = not area_tab.is_empty()

func _on_area_tab_area_exited(area: Area2D) -> void:
	area_tab.erase(area)
	$Imagen/Charlita.visible = not area_tab.is_empty()

# hacer viaje temporal y particulas

func go_viaje_temp(is_to_futuro: bool) -> void:
	if reloj_viaje == 0:
		var mi_mundo = get_parent().get_parent().name
		if is_to_futuro and mi_mundo == "MundoApocaliptico":
			return
		if not is_to_futuro and mi_mundo == "MundoFormacion":
			return
		is_al_futuro = is_to_futuro
		set_particulas() 

func set_particulas() -> void:
	$PartiUp.visible = true
	$PartiDown.visible = true
	var parts = $PartiUp.get_children()
	parts.append_array($PartiDown.get_children())
	for p in parts:
		p.initialize($PartiUp, $PartiDown)
		p.visible = false

func step_particulas(delta: float) -> void:
	if Data.DEBUG:
		delta *= 4
	if is_viaje_ida:
		var ant = reloj_viaje
		reloj_viaje = min(reloj_viaje + delta, TIME_VIAJE)
		if reloj_viaje == TIME_VIAJE:
			is_viaje_ida = false
			var nxt: String
			if is_al_futuro:
				nxt = Data.get_next_mundo(self, get_tree().get_nodes_in_group("mundos"))
			else:
				nxt = Data.get_prev_mundo(self, get_tree().get_nodes_in_group("mundos"))
			set_tiempo(nxt)
			for ent in get_tree().get_nodes_in_group("entes"):
				if ent.get_seleccionado():
					ent.set_tiempo(nxt)
		elif ant < TIME_VIAJE - 0.4 and reloj_viaje >= TIME_VIAJE - 0.4:
			gui.get_node("Anima").play("oscuro")
	else:
		reloj_viaje = max(reloj_viaje - delta, 0)
		if reloj_viaje == 0:
			is_viaje_ida = true
			$PartiUp.visible = false
			$PartiDown.visible = false
	var parts = $PartiUp.get_children()
	parts.append_array($PartiDown.get_children())
	var actual = (parts.size() * 2.0) * (reloj_viaje / TIME_VIAJE)
	for p in parts:
		p.step($PartiUp, $PartiDown, delta)
		p.visible = int(p.name.replace("P", "")) < actual

# seleccionar entes cercanos

func seleccionar() -> void:
	var entes = get_tree().get_nodes_in_group("entes")
	for ent in entes:
		if ent == self:
			continue
		if ent.get_envisto():
			ent.set_seleccionado(not ent.get_seleccionado())

func _on_tim_enmira_timeout() -> void:
	var entes = get_tree().get_nodes_in_group("entes")
	var cercano = Data.get_nearest(self, entes, CERCANO)
	for ent in entes:
		if ent == self:
			continue
		ent.set_envisto(ent == cercano)
		ent.no_seleccionado(self)
