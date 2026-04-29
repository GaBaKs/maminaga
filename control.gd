# menu_principal.gd
extends Control

func _on_start_button_pressed():
	# Cambia a la escena del mapa
	get_tree().change_scene_to_file("res://map.tscn")

func _on_shop_button_pressed():
	# Ir a la escena de compras (cuando la tengas)
	print("Abriendo tienda...")

#Ponele para mostrar los minerales
func _ready():
	$LabelMinerales.text = "Gemas: " + str(Global.minerales)
