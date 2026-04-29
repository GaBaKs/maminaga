extends CharacterBody2D

var vida = 100
var velocidad = 250

# Referencia a la barra de vida
@onready var barra_vida = $ProgressBar 

func _ready():
	# Al empezar, nos aseguramos que la barra coincida con la vida
	Global.referencia_jugador = self 
	barra_vida.max_value = vida
	barra_vida.value = vida
	self.mineral_recolectado.connect(_sumar_al_global)

func _physics_process(delta):
	# (Tu código de movimiento actual...)
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direccion * velocidad
	move_and_slide()

func recibir_danio(cantidad):
	vida -= cantidad
	# Actualizamos la barra visualmente
	barra_vida.value = vida
	
	print("Vida actual: ", vida)
	
	if vida <= 0:
		morir()

func morir():
	# Reinicia la escena o lo que prefieras
	get_tree().reload_current_scene()
	
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
