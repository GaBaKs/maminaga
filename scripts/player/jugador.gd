extends CharacterBody2D

var vida = 100
var velocidad = 250

# Variable para guardar la última dirección de movimiento
var ultima_direccion := Vector2.RIGHT

@onready var animated_sprite = $AnimatedSprite2D

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
	print("EL JUGADOR SE CARGÓ CORRECTAMENTE EN: ", global_position) # Agregá esto
	Global.referencia_jugador = self 
	if barra_vida:
		barra_vida.max_value = vida
		barra_vida.value = vida
	#self.mineral_recolectado.connect(_sumar_al_global)

func _physics_process(delta):
	# 1.(Tu código de movimiento actual...)
	animacion()
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
	barra_vida.value = vida
	if vida <= 0:
		morir()

func morir():
	# Evitamos llamar a get_tree().current_scene.find_child() aquí 
	Global.jugador_murio() 
	# NO uses queue_free() todavía, porque si el jugador desaparece, 
	# no podrá "revivir" en el mismo lugar después del anuncio.
	set_physics_process(false) # Pausamos su movimiento
	visible = false # Lo ocultamos temporalmente
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

func animacion():
	if velocity.x > 0:
		animated_sprite.play("run_right")

	elif velocity.x < 0:
		animated_sprite.play("run_left")

	else:
		if ultima_direccion.x > 0:
			animated_sprite.play("idle_right")

		elif ultima_direccion.x < 0:
			animated_sprite.play("idle_left")
