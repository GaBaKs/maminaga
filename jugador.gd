extends CharacterBody2D

var vida = 100
var velocidad = 250

# Variable para guardar la última dirección de movimiento
var ultima_direccion := Vector2.RIGHT

# Referencia a la barra de vida
@onready var barra_vida = $ProgressBar 

# --- VARIABLES DE DISPARO (OPCIÓN A) ---
@export var bala_escena: PackedScene # Arrastrá bala.tscn aquí en el Inspector
var recarga_disparo := 0.5
var timer_disparo := 0.0

# --- VARIABLES DE ÁREA (OPCIÓN B) ---
var danio_area := 1
var recarga_area := 1.0
var timer_area := 0.0

func _ready():
	# Al empezar, nos aseguramos que la barra coincida con la vida
	Global.referencia_jugador = self 
	barra_vida.max_value = vida
	barra_vida.value = vida
	self.mineral_recolectado.connect(_sumar_al_global)

func _physics_process(delta):
	# 1.(Tu código de movimiento actual...)
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direccion != Vector2.ZERO:
		ultima_direccion = direccion.normalized() # Guardamos hacia donde miramos
	velocity = direccion * velocidad
	move_and_slide()

	# 2. Lógica de Disparo Manual (Opción A)
	# Reemplazá tu línea del IF por esta para probar:
	if Input.is_action_just_pressed("ui_accept"):
		print("¡El botón funciona!") # Si ves esto en la consola, el botón está OK
		disparar()
	# 3. Lógica de Ataque de Área Pasivo (Opción B)
	timer_area += delta
	if timer_area >= recarga_area:
		ataque_circular()
		timer_area = 0

func recibir_danio(cantidad):
	vida -= cantidad
	# Actualizamos la barra visualmente
	barra_vida.value = vida
	
	print("Vida actual: ", vida)
	
	if vida <= 0:
		morir()

func morir():
	# Reinicia la escena o lo que prefieras
	print("El jugador murio")
	vida=400
	#get_tree().reload_current_scene()
	
signal mineral_recolectado(valor)

func _on_area_recoleccion_body_entered(body):
	if body.is_in_group("minerales"):
		mineral_recolectado.emit(1)
		body.queue_free() # Borra el mineral del mapa
func _sumar_al_global(valor):
	# AQUÍ es donde se incrementa la variable que vive en Global.gd
	Global.minerales += valor
	print("¡Gema recolectada! Total: ", Global.minerales)
	# En lugar de scale.x = -1, hacé:
	#Sprite2D.flip_h = true
func disparar():
	if bala_escena:
		var nueva_bala = bala_escena.instantiate()
		# En lugar de current_scene, lo agregamos al padre del jugador (el mapa)
		get_parent().add_child(nueva_bala) 
		nueva_bala.global_position = global_position
		nueva_bala.direccion = ultima_direccion
	else:
			print("ERROR: No hay escena cargada en bala_escena")
			
func ataque_circular():
	# Ahora que es hijo, $Area2D funcionará perfecto
	var enemigos = $Area2D.get_overlapping_bodies()
	
	for e in enemigos:
		if e.has_method("recibir_danio_enemigo"):
			# Calculamos hacia dónde empujar: (Posición Enemigo - Mi Posición)
			var direccion_empuje = (e.global_position - global_position).normalized()
			# Pasamos el daño y la dirección[cite: 5]
			e.recibir_danio_enemigo(danio_area, direccion_empuje)
