extends Area2D

func _ready():
	# Conectamos la señal de entrada
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		# Al tocar la meta, llamamos al cartel de victoria
		print("¡Llegaste a la meta!")
		Global.finalizar_partida(true) # Guarda los minerales permanentemente 
		if Global.cartel_interfaz:
			Global.cartel_interfaz.mostrar(true) # Muestra cartel de victoria
