extends Area2D
class_name MineralAbstract

@export var valor := 1

func _ready():
	# Aseguramos que pertenezca al grupo para que el jugador lo detecte 
	add_to_group("minerales") 
	# Conectamos la señal de colisión [cite: 5, 23]
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		# Usamos la función que ya tenés en Global
		Global.sumar_minerales(1) 
		# Efecto de sonido o partículas aquí
		queue_free()
func recolectar():
	# Emitimos la señal o sumamos al Global directamente 
	Global.sumar_minerales(valor)
	print("Mineral recolectado! Valor: ", valor, " Total: ", Global.minerales)
	queue_free() # Borra el mineral del mapa [cite: 5]
