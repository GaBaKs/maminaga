extends CharacterBody2D

var vida_actual=PlayerData.vida

# --- VARIABLES DE INVENTARIO TEMPORAL ---
var minerales_en_partida: Dictionary = {
	"mineral1": 0,
	"mineral2": 0,
	"mineral3": 0
}
# ----------------------------------------
var velocidad = 200
@onready var sonido_muerte = $Sonido_Muerte
@onready var sonido_pasos = $Pasos

# Variable para guardar la última dirección de movimiento
var ultima_direccion := Vector2.RIGHT
var yamurio= false
@onready var animated_sprite = $AnimatedSprite2D
@onready var joystick = $"../Joystick/Joystick"
@onready var arma_actual
# Referencia a la barra de vida
@onready var barra_vida = $ProgressBar 

# --- VARIABLES DE DISPARO (OPCIÓN A) ---
@export var bala_escena: PackedScene # Arrastrá bala.tscn aquí en el Inspector
var recarga_disparo := 0.5
var timer_disparo := 0.0

func _ready():
	Global.referencia_jugador = self 
	Global.jugador_revivio.connect(_on_revivio_jugador)
	resetear_recursos_temporales()
	
	if barra_vida:
		barra_vida.max_value = vida_actual
		barra_vida.value = vida_actual
		
		PlayerData.arma_escena = PlayerData.armas_disponibles[PlayerData.arma_equipada["nombre"]]
		arma_actual = PlayerData.arma_escena.instantiate()
		arma_actual.material_actual = PlayerData.arma_equipada["material"]
		add_child(arma_actual)
		print("arma actual:", arma_actual.nombre_arma, " de ", arma_actual.material_actual)
		arma_actual.position = Vector2.ZERO  # centrada en el jugador
		var ruta_skin = PlayerData.todas_las_skins[PlayerData.skin_actual]
		animated_sprite.sprite_frames = load(ruta_skin)
		print("SKIN SELECCIONADA: ",ruta_skin)

func _physics_process(delta):
	animacion()
	var direccion = joystick.direction
	velocity = direccion * velocidad
	
	# Guardamos la dirección para disparar cuando estamos quietos
	if direccion != Vector2.ZERO:
		ultima_direccion = direccion.normalized()
		
	move_and_slide()

# logica de regeneración de vida
	if not yamurio and vida_actual < PlayerData.vida:
		vida_actual += PlayerData.regen_vida * delta
		
		# Ponemos un tope para que no se pase de la vida máxima
		if vida_actual > PlayerData.vida:
			vida_actual = PlayerData.vida
			
		# Actualizamos la barra
		if barra_vida:
			barra_vida.value = vida_actual

func recibir_danio(cantidad):
	if yamurio:
		return 
		
	vida_actual -= cantidad*((100-PlayerData.armadura)/100)
	barra_vida.value = vida_actual
	
	if vida_actual <= 0:
		morir()

func morir():
	if yamurio:
		return 
		
	yamurio = true 
	
	animated_sprite.play("death")
	sonido_muerte.play()
	
	Global.emit_signal("jugador_murio", yamurio)
	set_physics_process(false)

func _on_revivio_jugador():
	vida_actual = PlayerData.vida
	yamurio = false # Corregido a false para que pueda volver a recibir daño
	set_physics_process(true)
	visible = true
	get_tree().paused = false
	
func disparar():
	if bala_escena:
		var nueva_bala = bala_escena.instantiate()
		get_parent().add_child(nueva_bala) 
		nueva_bala.global_position = global_position
		nueva_bala.direccion = ultima_direccion
	else:
		print("ERROR: No hay escena cargada en bala_escena")
			

func animacion():
	if yamurio:
		return
		
	if velocity != Vector2.ZERO:
		animated_sprite.play("walk")
		if not sonido_pasos.playing:
			sonido_pasos.play(1)
	else:
		animated_sprite.play("idle")
		sonido_pasos.stop()
	
	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false

func resetear_recursos_temporales():
	for key in minerales_en_partida.keys():
		minerales_en_partida[key] = 0
		
func sumar_minerales(tipo, cantidad):
	if minerales_en_partida.has(tipo):
		minerales_en_partida[tipo] += cantidad
