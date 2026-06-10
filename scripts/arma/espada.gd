extends ArmaAbstract
class_name ArmaEspada

func _ready() -> void:
	# Definimos el nombre y daño según el material dinámico
	nombre_arma = "Espada de " + material_actual.capitalize()
	
	var multiplicador = Global.MULTIPLICADOR_DANIO.get(material_actual, 2.0)
	danio = 40.0 * multiplicador + PlayerData.danio
	
	var velocidad_ataque = 0.7   
	alcance_radio = 50.0     
	distancia_al_jugador = 10.0
	
	timer_ataque = Timer.new()
	timer_ataque.wait_time = 3.0 / (velocidad_ataque + PlayerData.velocidad_ataque)
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
	
	sprite_ataque.visible = false
	sprite_ataque.animation_finished.connect(_on_animacion_terminada)
	
func _on_animacion_terminada():
	sprite_ataque.visible = false
	sprite_idle.visible = true

func atacar(objetivo: Node2D) -> void:
	super.atacar(objetivo)
	sprite_idle.visible = false
	sprite_ataque.visible = true
	
	# Si tenés animaciones de ataque por tier, cambialo acá como hicimos con el idle
	sprite_ataque.play("ataque")

func aplicar_danio(objetivo: Node2D) -> void:
	if is_instance_valid(objetivo) and objetivo.has_method("recibir_danio_enemigo"):
		print("¡Espadazo de ", material_actual , " a: ", objetivo.name, "! Daño aplicado: ", danio)
		var direccion_golpe = (objetivo.global_position - global_position).normalized()
		objetivo.recibir_danio_enemigo(danio, direccion_golpe)
