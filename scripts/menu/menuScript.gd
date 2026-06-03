extends Control



func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/seleccion_mapa.tscn")


func _on_equipo_pressed() -> void:
	pass # Replace with function body.
#desde aca (o la escena equipo ni idea) tenemos q 
#llamar a equipar_arma (q esta en global)

func _on_tienda_pressed() -> void:
	pass # Replace with function body.


func _on_estadisticas_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/estadisticas.tscn")
	pass # Replace with function body.
