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
		PlayerData.sumar_minerales(1) 
		print(PlayerData.minerales["Glacita"])
		# Efecto de sonido o partículas aquí
		queue_free()
		
