extends Enemigo_abstract


var proyectil = preload("res://escenas/enemigos/proyectiles/orbe_vampiro.tscn")
var cooldown_disparo := 1.0
var timer_disparo := 0.0
var distancia_disparo := 100.0  # distancia máxima para disparar
var disparando := false


func actualizar_animacion():
	var direccionAnimacion = "abajo"
	if disparando:  # animación de ataque
		if (direccion_actual.x <= -0.5):
			direccionAnimacion = "ataque izquierda"
		elif (direccion_actual.x >= 0.5):
			direccionAnimacion = "ataque derecha"
		elif (direccion_actual.y >= 0.5):
			direccionAnimacion = "ataque abajo"
		elif (direccion_actual.y <= -0.5):
			direccionAnimacion = "ataque arriba"
	else:
		if (direccion_actual.x <= -0.5):
			direccionAnimacion = "izquierda"
		elif (direccion_actual.x >= 0.5):
			direccionAnimacion = "derecha"
		elif (direccion_actual.y >= 0.5):
			direccionAnimacion = "abajo"
		elif (direccion_actual.y <= -0.5):
			direccionAnimacion = "arriba"
	get_node("AnimatedSprite2D").play(direccionAnimacion)

func _ready():
	super._ready()  # ejecuta el _ready() del padre (Enemigo_abstract)
	vida_enemigo = 100  
	$AnimatedSprite2D.animation_finished.connect(_on_animacion_terminada)
	
func _on_animacion_terminada():
	disparando = false
	
func _physics_process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		var distancia = global_position.distance_to(jugador.global_position)
		if distancia <= distancia_disparo: # está cerca → se frena y cuenta para disparar
			velocity = Vector2.ZERO
			move_and_slide() 
			if not disparando:
				timer_disparo -= delta
				if timer_disparo <= 0:
					disparando = true
					disparar()
					timer_disparo = cooldown_disparo
		else: # está lejos → se mueve normal
			disparando = false
			super._physics_process(delta)
	actualizar_animacion()
		
func disparar():
	if direccion_actual == null:
		return
	var nuevo_orbe = proyectil.instantiate()
	get_parent().add_child(nuevo_orbe)
	nuevo_orbe.global_position = global_position
	nuevo_orbe.direction = direccion_actual  # le pasa hacia dónde ir
	
