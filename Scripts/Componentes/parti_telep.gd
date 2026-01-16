extends Sprite2D

# altura
@onready var altu_base = offset.y
var altura: float = 0
var amplitud: float = 0 # +- desde el altu_base
var vel_ampli: float = 0 # velocidad de la altura
var tiempo_alt: float = 0 # tiempo que ha transcurrido

# posicion
var radio: float = 0 # alrrededor del punto central
var angulo: float = 0 # alrrededor del punto central
var vel_ang: float = 0 # velocidad del angulo
var tiempo_ang: float = 0 # tiempo que ha transcurrido

func initialize(nodo_up: Node, nodo_down: Node) -> void:
	# altura
	amplitud = randf_range(abs(altu_base * 0.2), abs(altu_base * 0.5))
	vel_ampli = randf_range(PI, 2.0 * PI)
	tiempo_alt = randf() * 60
	# posicion
	var dis = position.length()
	radio = randf_range(dis * 0.8, dis * 1.2)
	vel_ang = randf_range(PI, 2.0 * PI)
	tiempo_ang = randf() * 60
	draw(nodo_up, nodo_down)

func step(nodo_up: Node, nodo_down: Node, delta: float) -> void:
	# altura
	tiempo_alt += delta
	altura = altu_base + amplitud * sin(vel_ampli * tiempo_alt)
	# posicion
	tiempo_ang += delta
	angulo = vel_ang * tiempo_ang
	draw(nodo_up, nodo_down)

func draw(nodo_up: Node, nodo_down: Node) -> void:
	# altura
	offset.y = altura
	# posicion
	position = Vector2(radio, 0).rotated(angulo)
	var parent = get_parent()
	if position.y < 0:
		if nodo_up != parent:
			parent.remove_child(self)
			nodo_up.add_child(self)
	else:
		if nodo_down != parent:
			parent.remove_child(self)
			nodo_down.add_child(self)
