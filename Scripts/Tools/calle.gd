extends Sprite2D

enum TABLA { DEST, COST, NEXT }

@export var conexion: Array[Node] = []

var tabla = []
var iteracion = 0

func _ready() -> void:
	visible = false
	for c in conexion:
		set_direct(c)

func set_direct(dest: Node) -> void:
	var cost = position.distance_to(dest.position)
	set_conexion(dest, cost, dest)

func set_conexion(dest: Node, cost: float, next: Node) -> void:
	for t in tabla:
		if t[TABLA.DEST] == dest:
			if t[TABLA.COST] > cost:
				t[TABLA.COST] = cost
				t[TABLA.NEXT] = next
			return
	var t = [dest, cost, next]
	tabla.append(t)

func _process(_delta: float) -> void:
	for a in tabla:
		if a[TABLA.DEST] == a[TABLA.NEXT]:
			for b in a[TABLA.DEST].tabla:
				if b[TABLA.DEST] != self:
					var cost = a[TABLA.COST] + b[TABLA.COST]
					var c = find_dest(b[TABLA.DEST])
					if c.is_empty():
						set_conexion(b[TABLA.DEST], cost, a[TABLA.DEST])
					elif c[TABLA.NEXT] == a[TABLA.DEST]:
						set_conexion(b[TABLA.DEST], cost, a[TABLA.DEST])
					elif cost < c[TABLA.COST]:
						set_conexion(b[TABLA.DEST], cost, a[TABLA.DEST])
	iteracion += 1
	if iteracion >= 100:
		set_process(false)

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
