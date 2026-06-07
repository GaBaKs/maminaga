extends CanvasLayer

@onready var label_almas = $Panel/VBoxContainer/LabelAlmas
@onready var label_minerales = $Panel/VBoxContainer/LabelMinerales

func _ready():
	visible = false
	# Escuchamos el pitazo final del Árbitro
	Global.partida_ganada.connect(mostrar_cartel_victoria)

func mostrar_cartel_victoria():
	var jugador = Global.referencia_jugador
	
	if jugador != null:
		# Leemos la mochila para mostrarle al jugador lo que logró sacar
		label_almas.text = "Almas recolectadas: " + str(jugador.almas_en_partida)
		label_minerales.text = "Minerales:\nAzul: " + str(jugador.minerales_en_partida["mineral1"]) + "\nVerde: " + str(jugador.minerales_en_partida["mineral2"]) + "\nRojo: " + str(jugador.minerales_en_partida["mineral3"])
	
	visible = true

func _on_boton_volver_menu_pressed():
	if Global.referencia_jugador != null:
		Global.referencia_jugador.resetear_recursos_temporales()
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")

#Si mueres: El jugador desaparece, sale la pantalla de Game Over y volvés al menú. La "mochila" nunca se pasó a PlayerData, por lo tanto, no se guardó. Perdista la partida limpiamente.

#Si ganas: El Árbitro transfiere los datos, guarda en disco y te muestra tu logro. Todo queda organizado sin mezclar UI con controles del personaje.
