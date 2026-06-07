extends ArmaAbstract
class_name ArmaPistola

@export var bala_escena: PackedScene # Arrastrá bala.tscn acá en el Inspector
@onready var velocidad_ataque: int = 0.5
func _ready() -> void:
	nombre_arma = "Pistola"
	danio = 25.0
	velocidad_ataque = 0.5
	alcance_radio = 250.0
	distancia_al_jugador = 25.0
	timer_ataque = Timer.new()
	timer_ataque.wait_time = 3.0 / ((velocidad_ataque+PlayerData.velocidad_ataque))
	print("Timer valor:", timer_ataque.wait_time)
	timer_ataque.one_shot = true
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)
	add_child(timer_ataque)
	super()
	
func aplicar_danio(objetivo: Node2D) -> void:
	if not bala_escena or not is_instance_valid(objetivo):
		return
		
	var nueva_bala = bala_escena.instantiate()
	nueva_bala.danio_bala = danio+PlayerData.danio
	print("daño bala: ",nueva_bala.danio_bala)
	# La agregamos al mapa (current_scene) para que se mueva independiente del jugador
	get_tree().current_scene.add_child(nueva_bala)
	
	nueva_bala.global_position = global_position
	# La dirección se calcula hacia el objetivo actual
	nueva_bala.direccion = (objetivo.global_position - global_position).normalized()
	
