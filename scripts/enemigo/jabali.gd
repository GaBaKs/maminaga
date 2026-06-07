extends Enemigo_abstract


var cooldown_ataque := 1.0
var timer_ataque := 0.0
var distancia_ataque := 40.0  
var atacando := false
var jugador_ref 


func actualizar_animacion():
	var direccionAnimacion = "abajo"
	if atacando:  # animación de ataque
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
	danio = 10
	if not $AnimatedSprite2D.animation_finished.is_connected(_on_animacion_terminada):
		$AnimatedSprite2D.animation_finished.connect(_on_animacion_terminada)
	

func _on_animacion_terminada():
	var anim = $AnimatedSprite2D.animation
	if anim.begins_with("ataque"):
		atacando = false
		atacar(jugador_ref)
	
func _physics_process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		jugador_ref = jugador 
		var distancia = global_position.distance_to(jugador.global_position)
		if distancia <= distancia_ataque: # está cerca → se frena y cuenta para disparar
			velocity = Vector2.ZERO
			move_and_slide() 
			if not atacando:
				timer_ataque -= delta
				if timer_ataque <= 0:
					atacando = true
					atacar(jugador)
					timer_ataque = cooldown_ataque
		else: # está lejos → se mueve normal
			atacando = false
			super._physics_process(delta)
	actualizar_animacion()
		
func atacar(jugador):
	if jugador.has_method("recibir_danio"):
		jugador.recibir_danio(danio)  # ajustá el daño
	
func reproducir_animacion_muerte():
	$AnimatedSprite2D.play("muerte")
	if not $AnimatedSprite2D.animation_finished.is_connected(_on_muerte_terminada):
		$AnimatedSprite2D.animation_finished.connect(_on_muerte_terminada)

func _on_muerte_terminada():
	queue_free()
	
