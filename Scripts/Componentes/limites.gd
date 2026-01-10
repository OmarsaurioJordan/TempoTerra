extends StaticBody2D

func _on_tim_rip_timeout() -> void:
	$TimRIP.start(randf_range(4, 6))
	for cll in $Navegacion.get_children():
		cll.rip()

func _on_tim_congestion_timeout() -> void:
	$TimCongestion.start(randf_range(60, 120))
	for cll in $Navegacion.get_children():
		cll.rand_congestion()
