extends ArmaAbstract
class_name Arco

@export var bala_escena: PackedScene # Arrastrá bala.tscn acá en el Inspector
@onready var velocidad_ataque: float = 0.5

func _ready() -> void:
	# Ajustamos la pistola al nuevo sistema de materiales
	nombre_arma = "arco de "+ material_actual.capitalize()
	
	var multiplicador = Global.MULTIPLICADOR_DANIO.get(material_actual, 1.0)
	danio = 25.0 * multiplicador + PlayerData.danio
	
	velocidad_ataque = 0.5
	alcance_radio = 250.0
	distancia_al_jugador = 25.0
	
	timer_ataque = Timer.new()
	timer_ataque.wait_time = 3.0 / (velocidad_ataque + PlayerData.velocidad_ataque)
	print("Timer valor:", timer_ataque.wait_time)
	timer_ataque.one_shot = true
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)
	add_child(timer_ataque)
	super()
	

	if (material_actual=="madera"):
		sprite_idle.play("idle0")
	elif (material_actual=="amatista"):
		sprite_idle.play("idle1")
	elif (material_actual=="ruby"):
		sprite_idle.play("idle2")
	elif (material_actual=="agatha"):
		sprite_idle.play("idle3")
	
func aplicar_danio(objetivo: Node2D) -> void:
	if not bala_escena or not is_instance_valid(objetivo):
		return
		
	var nueva_bala = bala_escena.instantiate()
	# El daño ahora escala con el tier de madera, amatista, etc.
	nueva_bala.danio_bala = danio + PlayerData.danio
	print("daño bala: ", nueva_bala.danio_bala, " (", material_actual, ")")
	
	# La agregamos al mapa (current_scene) para que se mueva independiente del jugador
	get_tree().current_scene.add_child(nueva_bala)
	
	nueva_bala.global_position = global_position
	# La dirección se calcula hacia el objetivo actual
	nueva_bala.direccion = (objetivo.global_position - global_position).normalized()
