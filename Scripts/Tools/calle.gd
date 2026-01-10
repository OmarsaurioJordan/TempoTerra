extends Sprite2D

enum TABLA { DEST, COST, NEXT }

@export var conexion: Array[Node] = []
@export var guerra: bool = false

var tabla = []
var iteracion = 0
var congestion = 0

func _ready() -> void:
	visible = false
	for c in conexion:
		set_direct(c)
		#draw_linea(c.position)

func rand_congestion() -> void:
	if not tabla.is_empty():
		var t = tabla.pick_random()
		congestion = randf_range(0, t[TABLA.COST])

func set_direct(dest: Node) -> void:
	var cost = position.distance_to(dest.position)
	var t = [dest, cost, dest]
	tabla.append(t)

func _process(_delta: float) -> void:
	rip()
	iteracion += 1
	if iteracion >= 100:
		set_process(false)

func rip() -> void:
	# buscar en toda la tabla
	for a in tabla:
		# las conexiones directas, es decir con vecinos dest = next
		if a[TABLA.DEST] == a[TABLA.NEXT]:
			# buscar en toda la tabla del destino
			for b in a[TABLA.DEST].tabla:
				# donde las conexiones no sean con el nodo actual que ejecuta
				if b[TABLA.DEST] == self:
					continue
				var cost = a[TABLA.COST] + b[TABLA.COST] + a[TABLA.DEST].congestion
				var c = find_dest(b[TABLA.DEST])
				if c.is_empty():
					var t = [b[TABLA.DEST], cost, a[TABLA.DEST]]
					tabla.append(t)
				elif c[TABLA.NEXT] == a[TABLA.DEST]:
					c[TABLA.COST] = cost
				elif cost < c[TABLA.COST]:
					c[TABLA.COST] = cost
					c[TABLA.NEXT] = a[TABLA.DEST]

func find_dest(dest: Node) -> Array:
	for t in tabla:
		if t[TABLA.DEST] == dest:
			return t
	return []

func get_next_calle(dest: Node) -> Node:
	var nxt = find_dest(dest)
	if not nxt.is_empty():
		return nxt[TABLA.NEXT]
	return null

func get_txt() -> String:
	var txt = "-> " + name + ":"
	for t in tabla:
		txt += "\n" + t[TABLA.DEST].name + ": " + t[TABLA.NEXT].name
	return txt

func draw_linea(pos_fin: Vector2) -> void:
	var linea = Line2D.new()
	get_parent().get_parent().get_node("Lineas").add_child(linea)
	linea.position = Vector2(0, 0)
	linea.add_point(position)
	var d = position.distance_to(pos_fin) * 0.475
	var g = position.direction_to(pos_fin)
	linea.add_point(position + g * d)

func is_guerra() -> bool:
	return guerra
