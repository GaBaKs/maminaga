extends Area2D

func _ready():
	# Conectamos la señal de entrada
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("jugador"):
		Global.ganar_partida()
