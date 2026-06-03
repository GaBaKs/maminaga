extends CharacterBody2D

var vida_actual=PlayerData.vida
var minerales=0
var almas=0
var velocidad=200
@onready var sonido_muerte = $Sonido_Muerte
@onready var sonido_pasos = $Pasos

# Variable para guardar la última dirección de movimiento
var ultima_direccion := Vector2.RIGHT
var yamurio= false
@onready var animated_sprite = $AnimatedSprite2D
@onready var joystick = $"../../Joystick/Joystick"
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
	Global.referencia_jugador = self 
	Global.jugador_revivio.connect(_on_revivio_jugador)
	
	if barra_vida:
		barra_vida.max_value = vida_actual
		barra_vida.value = vida_actual
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
	vida_actual -= cantidad
	barra_vida.value = vida_actual
	if vida_actual <= 0:
		morir()

func morir():
	get_tree().paused = true # pausamos el juego
	
	sonido_muerte.play()
		
	Global.emit_signal("jugador_murio",yamurio)
	
	yamurio=true
	set_physics_process(false) # Pausamos su movimiento
	visible = false
	
func _on_revivio_jugador():
		vida_actual=PlayerData.vida
		yamurio=true
		set_physics_process(true)
		visible = true
		get_tree().paused = false
	
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
	
	if velocity.x != 0:
		if not sonido_pasos.playing:
			sonido_pasos.play(1)
	else:
			sonido_pasos.stop()
	
	
	if velocity.x > 0:
		animated_sprite.play("run_right")

	elif velocity.x < 0:
		animated_sprite.play("run_left")

	else:
		if ultima_direccion.x > 0:
			animated_sprite.play("idle_right")

		elif ultima_direccion.x < 0:
			animated_sprite.play("idle_left")
