extends CharacterBody2D

const VIDA: int = 200
const SPEED: float = 300
const ALIMENTO: int = 20
const GRUPO: Data.GRUPO = Data.GRUPO.CYBORG

@onready var gui: Node = get_tree().get_nodes_in_group("gui")[0]

var vida: int = VIDA
var hogar: Node = null
var municion: int = 0
var cargador: int = 0 # municion actualmente en el arma
var especial: int = 0 # municion especial
var prepunteria: Vector2 = Vector2(0, 0) # direccion de disparo pre ajustada

var area_tab: Array = []
var linea: Line2D = null

func _ready() -> void:
	$Imagen/Charlita.visible = false
	call_deferred("set_camara_mundo")
	gui.get_node("Informacion").visible = false
	gui.get_node("Datos").visible = false

func initialize(_grp=0, _csa=null) -> void:
	$Imagen.initialize_obrera(GRUPO)
	$Imagen.initialize_warrior(GRUPO)

func get_grupo() -> Data.GRUPO:
	return GRUPO

func get_hogar_grupo() -> Data.GRUPO:
	if hogar != null:
		return hogar.grupo
	return Data.GRUPO.SOLO

func is_mele() -> bool:
	return $Imagen/Arma.visible

func get_dist_tech() -> int:
	return Data.distancia_to_tech($Imagen/Distancia.frame)

func get_archienemigo_grupo() -> Data.GRUPO:
	return Data.GRUPO.SOLO

func alimentar() -> void:
	vida = min(vida + ALIMENTO, VIDA)

func is_alimentable() -> bool:
	return vida < VIDA

func _physics_process(_delta: float) -> void:
	# cambiar de linea temporal
	if Input.is_action_just_pressed("ui_futuro"):
		set_tiempo(Data.get_next_mundo(self, get_tree().get_nodes_in_group("mundos")))
	elif Input.is_action_just_pressed("ui_pasado"):
		set_tiempo(Data.get_prev_mundo(self, get_tree().get_nodes_in_group("mundos")))
	# moverse por el suelo
	var dir: Vector2 = Input.get_vector("ui_izquierda", "ui_derecha", "ui_arriba", "ui_abajo")
	if dir.length() != 0:
		velocity = dir * SPEED
	else:
		velocity = Vector2(0, 0)
	move_and_slide()
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
		elif not area_tab.is_empty():
			gui.get_node("Informacion").visible = true
			var base = area_tab[0].get_parent()
			gui.get_node("Informacion/Texto").text =\
				gui.get_node("Datos/G" + str(base.get_grupo())).text
	# disparar
	if Input.is_action_pressed("ui_disparo"):
		if municion + cargador > 0:
			if cargador == 0 and $Shots/TimShotCargador.is_stopped():
				$Shots/TimShotCargador.start(Data.RECARGAS[get_dist_tech()])
				$Imagen/Anima.play("recharge")
			elif $Shots/TimShotDistance.is_stopped() and $Shots/TimShotCargador.is_stopped():
				$Shots/TimShotGo.start()
				$Shots/TimShotDistance.start(Data.CADENCIA[get_dist_tech()])
				$Imagen/Anima.play("shot")
				cargador -= 1

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
			gui.get_node("TxtEra").text = "Ancient"
		"MundoPrehistoria":
			gui.get_node("TxtEra").text = "Ice Age"
		"MundoAntiguo":
			gui.get_node("TxtEra").text = "Tribal"
		"MundoImperial":
			gui.get_node("TxtEra").text = "Imperial"
		"MundoMedieval":
			gui.get_node("TxtEra").text = "Medieval"
		"MundoIndustrial":
			gui.get_node("TxtEra").text = "Industrial"
		"MundoModerno":
			gui.get_node("TxtEra").text = "Modern"
		"MundoAvanzado":
			gui.get_node("TxtEra").text = "Futuristic"
		"MundoApocaliptico":
			gui.get_node("TxtEra").text = "Apocalyptic"

func set_tiempo(nombre_mundo: String) -> void:
	if nombre_mundo != "":
		var mundo = get_parent().get_parent().get_parent().get_node(nombre_mundo)
		var pos = position
		get_parent().remove_child(self)
		mundo.get_node("Objetos").add_child(self)
		position = pos
		call_deferred("set_camara_mundo")

func _on_area_tab_area_entered(area: Area2D) -> void:
	if not area in area_tab:
		area_tab.append(area)
	$Imagen/Charlita.visible = not area_tab.is_empty()

func _on_area_tab_area_exited(area: Area2D) -> void:
	area_tab.erase(area)
	$Imagen/Charlita.visible = not area_tab.is_empty()

func _on_tim_shot_go_timeout() -> void:
	if is_mele():
		pass
	else:
		var dir = global_position.direction_to(get_global_mouse_position())
		Data.crea_proyectil(self, dir, get_dist_tech())

func hit_proyectil(ind_tech: int) -> void:
	pass

func _on_tim_shot_cargador_timeout() -> void:
	var tech = get_dist_tech()
	while cargador < Data.CARGADOR[tech] and municion > 0:
		cargador += 1
		municion -= 1
	$Imagen/Anima.play("RESET")
	if municion + cargador <= 1:
		$Imagen/Municion.visible = false

func _on_anima_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"shot":
			if cargador == 0 and municion > 0:
				$Shots/TimShotCargador.start(Data.RECARGAS[get_dist_tech()])
				$Imagen/Anima.play("recharge")
			elif municion + cargador == 0 and $Imagen/Distancia.frame != 4: # arco
				$Imagen.set_mele()
