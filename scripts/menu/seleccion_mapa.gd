extends Node

# Tus iconos/opciones (podés poner texturas, nombres, etc)
var opciones = ["BosqueIcono", "HieloIcono", "VolcanIcono"]  
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

	Global.nivel_a_cargar=proximo_nivel
	get_tree().change_scene_to_file("res://escenas/mapas/map_Bosque_v2.tscn")

func animar_cambio():
	# Animación simple con Tween
	var tween = create_tween()
	tween.tween_property(display, "modulate:a", 0.0, 0.1)  # fade out
	tween.tween_callback(func(): actualizar_display())
	tween.tween_property(display, "modulate:a", 1.0, 0.1)  # fade in

func actualizar_display():
	display.texture = load("res://assets/menu/iconosMapas/" + opciones[indice_actual] + ".jpg")
	print(opciones[indice_actual])  # acá cambiás la textura o label
