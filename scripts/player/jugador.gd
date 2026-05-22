extends CharacterBody2D

var vida = 100
var velocidad = 250

# Variable para guardar la última dirección de movimiento
var ultima_direccion := Vector2.RIGHT

@onready var animated_sprite = $AnimatedSprite2D
@onready var joystick = $"../Joystick/Joystick"
@onready var arma_actual
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
	if barra_vida:
		barra_vida.max_value = vida
		barra_vida.value = vida
	#self.mineral_recolectado.connect(_sumar_al_global)
	if Global.arma_escena:
		arma_actual = Global.arma_escena.instantiate()
		add_child(arma_actual)
		arma_actual.position = Vector2.ZERO  # centrada en el jugador

func _physics_process(delta):
	animacion()
	var direccion = joystick.direction
	velocity = direccion * velocidad
	move_and_slide()


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
