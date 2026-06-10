extends Node

# Tus iconos/opciones
var opciones = ["logo_bosque", "logo_hielo", "logo_muerte"]  
var indice_actual = 0
var proximo_nivel

# Referencias a tus nodos
@onready var display = $HBoxContainer/BosqueIcono  
@onready var boton_jugar = $HBoxContainer/Jugar
@onready var lbutton = $HBoxContainer/LButton
@onready var rbutton = $HBoxContainer/RButton
@onready var pergamino1 = $HBoxContainer/PergaminoLateral
@onready var pergamino2 = $HBoxContainer/PergaminoLateral2


# === NUEVAS REFERENCIAS (Ajustá las rutas a donde estén tus botones realmente) ===
@onready var menu_dificultades = $TextureRectDificultades # Referencia directa al contenedor padre
@onready var boton_facil = $TextureRectDificultades/HBoxContainer2/BotonFacil 
@onready var boton_normal = $TextureRectDificultades/HBoxContainer2/BotonNormal
@onready var boton_dificil = $TextureRectDificultades/HBoxContainer2/BotonDificil

func _ready():
	# ESTADO INICIAL: Cuando arranca la escena
	# El botón jugar arranca habilitado y visible
	boton_jugar.show()
	boton_jugar.disabled = false
	
	# Ocultamos el recuadro de dificultades al inicio
	menu_dificultades.hide()

func _on_lbutton_pressed():  
	indice_actual = (indice_actual - 1 + opciones.size()) % opciones.size()
	animar_cambio()

func _on_rbutton_pressed():  
	indice_actual = (indice_actual + 1) % opciones.size()
	animar_cambio()
	
func animar_cambio():
	var tween = create_tween()
	tween.tween_property(display, "modulate:a", 0.0, 0.1)  
	tween.tween_callback(func(): actualizar_display())
	tween.tween_property(display, "modulate:a", 1.0, 0.1)  

func actualizar_display():
	display.texture = load("res://assets/menu/iconosMapas/" + opciones[indice_actual] + ".png")
	print(opciones[indice_actual])  

func _on_jugar_pressed():
	# Al apretar jugar, mostramos las dificultades y bloqueamos jugar para que no lo aprieten de nuevo
	lbutton.hide()
	rbutton.hide()
	pergamino1.hide()
	pergamino2.hide()
	boton_jugar.hide()
	menu_dificultades.show()
	boton_jugar.disabled = true

func _on_boton_facil_pressed() -> void:
	Global.dificultad_actual = 0
	iniciar_partida()

func _on_boton_normal_pressed() -> void:
	Global.dificultad_actual = 1
	iniciar_partida()

func _on_boton_dificil_pressed() -> void:
	Global.dificultad_actual = 2
	iniciar_partida()

func iniciar_partida():
	# Esta función junta la lógica que antes tenías en el botón Jugar
	print("Iniciando mapa en dificultad: ", Global.dificultad_actual)
	
	if (indice_actual == 0):
		proximo_nivel = "res://escenas/mapas/map_Bosque_v2.tscn"
	elif (indice_actual == 1):
		proximo_nivel = "res://escenas/mapas/mapa_abismo_de_los_lamentos.tscn"
	elif (indice_actual == 2):
		proximo_nivel = "res://escenas/mapas/mapa_oscuro.tscn"
		
	print("Cargando: ", proximo_nivel)
	Global.nivel_a_cargar = proximo_nivel
	get_tree().change_scene_to_file(proximo_nivel)

func _on_volver_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
