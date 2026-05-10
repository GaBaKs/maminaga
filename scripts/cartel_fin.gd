extends CanvasLayer
@onready var titulo = $Panel/Label  # Quita el "Panel/" si no tienes un nodo Panel
@onready var boton_revivir = $Panel/Label/BotonRevivir # Asegúrate que el nombre sea idéntico al del nodo
@onready var boton_reintentar = $Panel/Label/BotonReintentar
func _ready():
	# ¡ESTO ES VITAL! Si no, Global2.cartel_interfaz siempre será null
	Global.cartel_interfaz = self 
	visible = false

func mostrar(victoria: bool):
	visible = true
	get_tree().paused = true # Pausamos el juego para que nada se mueva [cite: 8]
	
	if victoria:
		titulo.text = "¡Nivel Completado!"
		boton_revivir.visible = false # No se revive si ya ganaste [cite: 9]
	else:
		titulo.text = "Has caído..."
		boton_revivir.visible = true # Botón para ver anuncio y revivir [cite: 9]

func _on_boton_revivir_pressed():
	get_tree().paused = false
	visible = false
	Global.revivir_jugador() # [cite: 9]

func _on_boton_reintentar_pressed():
	get_tree().paused = false
	Global.finalizar_partida(false) # Se pierden los minerales de la partida 
	get_tree().reload_current_scene()
