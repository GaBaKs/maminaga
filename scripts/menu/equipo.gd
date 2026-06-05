extends Control

# Asegúrate de arrastrar tus botones aquí desde el panel de Nodos
@onready var btn_espada = $boton_espada
@onready var btn_pistola = $boton_pistola
@onready var btn_baculo = $boton_baculo

func _ready():
	compradas()

func compradas():
	# Evaluamos cada botón pasando el nodo y el ID del arma
	configurar_boton(btn_espada, "espada")
	configurar_boton(btn_pistola, "pistola")
	configurar_boton(btn_baculo, "baculo")

func configurar_boton(boton: Button, id_arma: String):
	if PlayerData.armas_compradas.has(id_arma):
		if PlayerData.arma_equipada == id_arma:
			boton.text = "Equipado" 
			boton.disabled = true
		else:
			boton.text = "Equipar"
			boton.disabled = false
	else:
		boton.text = "Comprar"
		boton.disabled = false

func _on_boton_espada_pressed():
	procesar_accion_arma("espada")

func _on_boton_pistola_pressed():
	procesar_accion_arma("pistola")

func _on_boton_baculo_pressed():
	procesar_accion_arma("baculo")

func procesar_accion_arma(id_arma: String):
	if PlayerData.armas_compradas.has(id_arma):
		# Si ya la tiene, la equipa
		PlayerData.equipar_arma(id_arma)
	else:
		# Si no la tiene, ejecutamos la lógica de compra
		comprar_arma(id_arma)
	
	# Refrescamos la interfaz para que los textos de los botones cambien
	compradas()

func comprar_arma(id_arma: String):
	#aca van los costos de las armas
	var costo = 50 
	if PlayerData.minerales["mineral1"] >= costo:
		PlayerData.minerales["mineral1"] -= costo
		PlayerData.armas_compradas.append(id_arma)
		PlayerData.guardar_datos()
		print("Arma comprada: ", id_arma)
	else:
		print("No tienes suficientes minerales")
		
func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
