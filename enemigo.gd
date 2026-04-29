extends CharacterBody2D
class_name Enemigo_abstract

@export var speed := 100
var objetivo = Global.referencia_jugador
# Ya no necesitamos la variable 'jugador' con @onready aquí arriba 
# porque la buscaremos dinámicamente.

func _ready():
	print("Enemigo preparado")

func _physics_process(delta):
	# Buscamos al jugador en cada frame si no lo tenemos, 
	# o simplemente lo buscamos una vez.
	var jugador = get_tree().get_first_node_in_group("jugador")

	if jugador: 
		# 1. Cálculo de dirección: (Destino - Origen)
		var direction = (jugador.global_position - global_position).normalized()
		
		# 2. Aplicar velocidad
		velocity = direction * speed
		
		# 3. Mover y deslizar
		move_and_slide() 
		
		# 4. Lógica de daño por contacto
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var objeto_chocado = collision.get_collider()
			if objeto_chocado.has_method("recibir_danio"):
				objeto_chocado.recibir_danio(0.5)
	else:
		# Si no encuentra al jugador, imprimimos un error para saber qué pasa
		print("Error: No encuentro a nadie en el grupo 'jugador'")
