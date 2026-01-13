extends Node2D

func initialize(new_parent: Node, posicion: Vector2, tipo: int) -> void:
	# 0:morado, 1:humo, 2:fuego
	visible = true
	for img in $Imagen.get_children():
		img.visible = img.name == "Img" + str(tipo)
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = posicion
	$Anima.speed_scale = randf_range(0.5, 1)
	$Anima.play("explota")

func _on_anima_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explota":
		visible = false
