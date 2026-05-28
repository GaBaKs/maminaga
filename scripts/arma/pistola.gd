extends ArmaAbstract
class_name ArmaPistola

@export var bala_escena: PackedScene # Arrastrá bala.tscn acá en el Inspector

func _ready() -> void:
	nombre_arma = "Pistola"
	danio = 25.0
	velocidad_ataque = 1.0
	alcance_radio = 250.0
	distancia_al_jugador = 25.0
	super() 
	
func aplicar_danio(objetivo: Node2D) -> void:
	if not bala_escena or not is_instance_valid(objetivo):
		return
		
	var nueva_bala = bala_escena.instantiate()
	# La agregamos al mapa (current_scene) para que se mueva independiente del jugador
	get_tree().current_scene.add_child(nueva_bala)
	
	nueva_bala.global_position = global_position
	# La dirección se calcula hacia el objetivo actual
	nueva_bala.direccion = (objetivo.global_position - global_position).normalized()
	nueva_bala.danio_bala = danio
