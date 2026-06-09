extends CanvasLayer

@onready var label_mineral1 = $VBoxContainer/HBoxContainer/LabelMin1
@onready var label_mineral2 = $VBoxContainer/HBoxContainer2/LabelMin2
@onready var label_mineral3 = $VBoxContainer/HBoxContainer3/LabelMin3

func _ready():
	visible = false
	# Escuchamos el pitazo final del Árbitro
	Global.partida_ganada.connect(mostrar_cartel_victoria)

func mostrar_cartel_victoria():
	print("¡EL CARTEL RECIBIÓ LA SEÑAL Y DEBERÍA MOSTRARSE!") # <-- Agregá esto
	var jugador = Global.referencia_jugador
	
	if jugador != null:
		# Leemos la mochila para mostrarle al jugador lo que logró sacar
		label_mineral1.text = "Cantidad de amatista recolectada: " + str(jugador.minerales_en_partida["mineral1"]) 
		label_mineral2.text = "Cantidad de rubi recolectado: " + str(jugador.minerales_en_partida["mineral2"]) 
<<<<<<< Updated upstream
		label_mineral3.text = "Cantidad de agatha recolectada:" + str(jugador.minerales_en_partida["mineral3"])
=======
>>>>>>> Stashed changes
		label_mineral3.text = "Cantidad de agatha recolectada: " + str(jugador.minerales_en_partida["mineral3"])
	
	visible = true

func _on_boton_volver_menu_pressed():
	if Global.referencia_jugador != null:
		Global.referencia_jugador.resetear_recursos_temporales()
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")

#Si mueres: El jugador desaparece, sale la pantalla de Game Over y volvés al menú. La "mochila" nunca se pasó a PlayerData, por lo tanto, no se guardó. Perdista la partida limpiamente.

#Si ganas: El Árbitro transfiere los datos, guarda en disco y te muestra tu logro. Todo queda organizado sin mezclar UI con controles del personaje.
