extends ArmaAbstract
class_name ArmaLaser

@export var color_laser: Color = Color.RED
func _ready() -> void:
	nombre_arma = "Pistola"
	danio = 25.0
	velocidad_ataque = 1.0
	alcance_radio = 250.0
	distancia_al_jugador = 25
	super()  # llama al _ready() del padre DESPUÉS de setear los valores
	

func atacar(objetivo: Node2D) -> void:
	super(objetivo)  # maneja el timer y puede_atacar
	
	if is_instance_valid(objetivo):
		print("Pistola dispara a: ", objetivo.name, " | Daño: ", danio)
		
		if objetivo.has_method("recibir_danio_enemigo"):
			var direccion = (objetivo.global_position - global_position).normalized()
			objetivo.recibir_danio_enemigo(danio, direccion)
