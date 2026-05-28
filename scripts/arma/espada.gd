extends ArmaAbstract
class_name ArmaEspada

func _ready() -> void:
	nombre_arma = "Espada Básica"
	danio = 40.0             # Más daño que la pistola
	velocidad_ataque = 1.5   # Ataque medianamente rápido
	alcance_radio = 70.0     # Alcance muy corto (cuerpo a cuerpo)
	distancia_al_jugador = 30.0
	super() 

func aplicar_danio(objetivo: Node2D) -> void:
	if is_instance_valid(objetivo) and objetivo.has_method("recibir_danio_enemigo"):
		# Como es una espada, el golpe se aplica directo al cuerpo
		print("¡Espadazo a: ", objetivo.name, "!")
		var direccion_golpe = (objetivo.global_position - global_position).normalized()
		objetivo.recibir_danio_enemigo(danio, direccion_golpe)
