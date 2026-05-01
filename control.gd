# menu_principal.gd
extends Control

var lista_skins = ["adventurer", "mago", "noseqseyo"]
var indice_actual = 0

@onready var preview = $HBoxContainer/VBoxContainer_Selector/HBoxContainer/TextureRect_Preview
@onready var label_puntos = $HBoxContainer/VBoxContainer_Info/Label_Minerales


func _on_start_button_pressed():
	# Cambia a la escena del mapa
	get_tree().change_scene_to_file("res://map.tscn")

func _on_shop_button_pressed():
	# Ir a la escena de compras (cuando la tengas)
	print("Abriendo tienda...")

func _ready():
	# Mostramos los puntos que vienen del Global[cite: 5]
	label_puntos.text = "Gemas: " + str(Global.minerales)
	actualizar_visual_skin()

func _on_button_next_pressed():
	indice_actual = (indice_actual + 1) % lista_skins.size()
	Global.skin_actual = lista_skins[indice_actual] # Guardamos en el Singleton[cite: 5]
	actualizar_visual_skin()

func _on_button_prev_pressed():
	indice_actual = (indice_actual - 1 + lista_skins.size()) % lista_skins.size()
	Global.skin_actual = lista_skins[indice_actual]
	actualizar_visual_skin()

func actualizar_visual_skin():
	# Aquí cambiarías la textura del recuadro según el nombre de la skin
	# preview.texture = load("res://assets/" + Global.skin_actual + ".png")
	print("Skin seleccionada: ", Global.skin_actual)

func _on_button_start_pressed():
	# Cambia a la escena del bosque que ya tienen[cite: 10]
	get_tree().change_scene_to_file("res://map_bosque.tscn")
