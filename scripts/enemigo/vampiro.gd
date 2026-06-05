extends Enemigo_abstract


var proyectil = preload("res://escenas/enemigos/proyectiles/orbe_vampiro.tscn")
var cooldown_disparo := 2.0
var timer_disparo := 0.0


func actualizar_animacion():
	var direccionAnimacion = "abajo"
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
	
	
func _physics_process(delta):
	super._physics_process(delta)  # lógica del padre
	actualizar_animacion()         # actualiza la animación cada frame
	
	timer_disparo -= delta
	if timer_disparo <= 0:
		disparar()
		timer_disparo = cooldown_disparo
		
func disparar():
	if direccion_actual == null:
		return
	var nuevo_orbe = proyectil.instantiate()
	get_parent().add_child(nuevo_orbe)
	nuevo_orbe.global_position = global_position
	nuevo_orbe.direction = direccion_actual  # le pasa hacia dónde ir
	
