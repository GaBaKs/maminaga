extends Area2D
class_name MineralAbstract

@export var valor := 1
@export var tipo_mineral: String = "" # Nueva variable para identificar la gema

func _ready():
	# Aseguramos que pertenezca al grupo para que el jugador lo detecte
	add_to_group("minerales") 
	# Conectamos la señal de colisión
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		# Ahora le pasamos el tipo de mineral y la cantidad al PlayerData
		# (Asegurate de que PlayerData.sumar_minerales reciba estos dos parámetros)
		PlayerData.sumar_minerales(tipo_mineral, valor) 
		
		print("Recogido: ", tipo_mineral, " | Total: ", PlayerData.minerales[tipo_mineral])
		
		# Efecto de sonido o partículas aquí (puedes instanciar un nodo de partículas antes de borrarlo)
		queue_free()
