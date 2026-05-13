extends CharacterBody2D
class_name Enemigo_abstract

@export var speed := 100
var vida_enemigo = 3
var fuerza_retroceso := Vector2.ZERO
# Ya no necesitamos la variable 'jugador' con @onready aquí arriba 
# porque la buscaremos dinámicamente.

func _ready():
	print("Enemigo preparado")
	if Global.dificultad_actual == 3:
		speed = 150
	else: 
		if Global.dificultad_actual == 2:
			speed = 120
		else:
			if Global.dificultad_actual == 1:
				speed = 100
		


func _physics_process(delta):
	if fuerza_retroceso.length() > 10:
		velocity = fuerza_retroceso
		fuerza_retroceso = fuerza_retroceso.lerp(Vector2.ZERO, 0.1)
	else:
		var jugador = get_tree().get_first_node_in_group("jugador")
		if jugador: 
			var direction = (jugador.global_position - global_position).normalized()
			velocity = direction * speed
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var objeto_chocado = collision.get_collider()
				if objeto_chocado and objeto_chocado.has_method("recibir_danio"):
					objeto_chocado.recibir_danio(0.5)
		else:
			velocity = Vector2.ZERO
	# IMPORTANTE: move_and_slide() siempre afuera para que procese cualquier velocity
	move_and_slide()

func morir_enemigo():
	# 1. Cambiar Global por Global2 (o como se llame tu Autoload) [cite: 11]
	Global.almas += 1
	print("¡Alma recolectada! Almas totales: ", Global.almas)
	# 2. Eliminar al enemigo [cite: 5]
	queue_free()
	# El move_and_slide() se llama UNA SOLA VEZ al final para aplicar la velocity que sea
	
func recibir_danio_enemigo(cantidad,direccion_golpe: Vector2):
	vida_enemigo -= cantidad
	# Aplicamos el empuje: dirección del golpe * intensidad
	fuerza_retroceso = direccion_golpe * 500
	if vida_enemigo <= 0:
		morir_enemigo()
