extends CharacterBody2D

const SPEED = 300.0

const GRUPO: Data.GRUPO = Data.GRUPO.CYBORG

func _ready() -> void:
	call_deferred("set_camara_mundo")

func initialize(_grp=0) -> void:
	$Imagen.initialize_obrera(GRUPO)
	$Imagen.initialize_warrior(GRUPO)

func get_grupo() -> Data.GRUPO:
	return GRUPO

func _physics_process(delta: float) -> void:
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

func set_tiempo(nombre_mundo: String) -> void:
	if nombre_mundo != "":
		var mundo = get_parent().get_parent().get_parent().get_node(nombre_mundo)
		var pos = position
		get_parent().remove_child(self)
		mundo.get_node("Objetos").add_child(self)
		position = pos
		call_deferred("set_camara_mundo")
