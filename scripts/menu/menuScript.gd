extends Control



func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/seleccion_mapa.tscn")


func _on_equipo_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/equipo.tscn")
#llamar a equipar_arma (q esta en global)



func _on_estadisticas_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/estadisticas.tscn")



func _on_aspectos_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/aspectos.tscn")
