extends Node

# Aquí defines a qué nivel quieres ir después de la carga
var proximo_nivel = "res://escenas//map_bosque.tscn"

func _on_button_pressed() -> void:
	# 1. Guardamos la ruta en un lugar donde la pantalla de carga la pueda leer
	# Para esto usamos una variable global (Autoload) o una clase estática
	Global.nivel_a_cargar = proximo_nivel
	
	# 2. Cambiamos a la escena de la animación (la que tiene el ResourceLoader)
	get_tree().change_scene_to_file("res://escenas/loading_screen.tscn")
