extends Node

# Tus iconos/opciones (podés poner texturas, nombres, etc)
var opciones = ["logo_bosque", "logo_hielo", "logo_muerte"]  
var indice_actual = 0
var proximo_nivel

# Referencia al nodo que muestra el ícono central
@onready var display = $HBoxContainer/BosqueIcono  

func _on_lbutton_pressed():  # Flecha izquierda
	indice_actual = (indice_actual - 1 + opciones.size()) % opciones.size()
	animar_cambio()

func _on_rbutton_pressed():  # Flecha derecha
	indice_actual = (indice_actual + 1) % opciones.size()
	animar_cambio()
	
func _on_jugar_pressed():
	proximo_nivel = "res://escenas/map_Bosque_v2.tscn"
	print("Cargando: ", proximo_nivel)
	
	
	if (indice_actual == 0):
		proximo_nivel=("res://escenas/mapas/map_Bosque_v2.tscn")
	else:
		if (indice_actual == 1):
			proximo_nivel=("res://escenas/mapas/mapa_abismo_de_los_lamentos.tscn")
		else:
			if (indice_actual == 2):
				proximo_nivel=("res://escenas/mapas/mapa_oscuro.tscn")
	Global.nivel_a_cargar=proximo_nivel
	get_tree().change_scene_to_file(proximo_nivel)
	
func animar_cambio():
	# Animación simple con Tween
	var tween = create_tween()
	tween.tween_property(display, "modulate:a", 0.0, 0.1)  # fade out
	tween.tween_callback(func(): actualizar_display())
	tween.tween_property(display, "modulate:a", 1.0, 0.1)  # fade in

func actualizar_display():
	display.texture = load("res://assets/menu/iconosMapas/" + opciones[indice_actual] + ".png")
	print(opciones[indice_actual])  # acá cambiás la textura o label


func _on_volver_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
	pass # Replace with function body.
