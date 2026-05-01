extends CharacterBody2D
class_name Enemigo_abstract

@export var speed := 100
var vida_enemigo = 3
var objetivo = Global.referencia_jugador
var fuerza_retroceso := Vector2.ZERO
# Ya no necesitamos la variable 'jugador' con @onready aquí arriba 
# porque la buscaremos dinámicamente.

func _ready():
	print("Enemigo preparado")

func _physics_process(delta):
	# Primero, verificamos si hay una fuerza de retroceso activa
	if fuerza_retroceso.length() > 10:
		# ESTADO RETROCESO: La prioridad es el empuje
		velocity = fuerza_retroceso
		# Aplicamos "fricción" para que se detenga poco a poco
		fuerza_retroceso = fuerza_retroceso.lerp(Vector2.ZERO, 0.1)
	else:
		# ESTADO PERSECUCIÓN: Tu lógica original
		var jugador = get_tree().get_first_node_in_group("jugador")

		if jugador: 
			# 1. Cálculo de dirección
			var direction = (jugador.global_position - global_position).normalized()
			# 2. Aplicar velocidad normal
			velocity = direction * speed
			
			# Lógica de daño por contacto (la movemos aquí adentro)
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var objeto_chocado = collision.get_collider()
				if objeto_chocado != null: 
					if objeto_chocado.has_method("recibir_danio"):
						objeto_chocado.recibir_danio(0.5)
					else:
						velocity = Vector2.ZERO
						print("Error: No encuentro a nadie en el grupo 'jugador'")
		move_and_slide()
		
	# El move_and_slide() se llama UNA SOLA VEZ al final para aplicar la velocity que sea
	
func recibir_danio_enemigo(cantidad,direccion_golpe: Vector2):
	vida_enemigo -= cantidad
	# Aplicamos el empuje: dirección del golpe * intensidad
	fuerza_retroceso = direccion_golpe * 500
	if vida_enemigo <= 0:
		morir_enemigo()

func morir_enemigo():
	# Accedemos a la variable 'almas' de tu script global2.gd
	Global.almas += 1 
	print("¡Alma recolectada! Almas totales: ", Global.almas)
	
	# Eliminamos al enemigo de la escena[cite: 5]
	queue_free()
