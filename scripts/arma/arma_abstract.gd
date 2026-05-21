# arma_abstract.gd
extends Node2D
class_name ArmaAbstract

@export var nombre_arma: String = "Arma Base"
@export var danio: float = 10.0
@export var velocidad_ataque: float = 2.0 # Cuántas veces ataca por segundo
@export var alcance_radio: float = 200.0

@onready var collision_shape = $CollisionShape2D

var puede_atacar: bool = true
var enemigos_al_alcance: Array[Node2D] = []
var timer_ataque: Timer

func _ready() -> void:
	# Ajustamos el radio del Area2D según el alcance
	if collision_shape and collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = alcance_radio
	
	$Area2D.body_entered.connect(_on_body_entered)  # ✅
	$Area2D.body_exited.connect(_on_body_exited)
	
	# Creamos el temporizador interno invisible para controlar los ataques por segundo
	timer_ataque = Timer.new()
	timer_ataque.name = "TimerAtaque"
	# Aplicamos la fórmula matemática para pasar de "ataques por segundo" a "segundos de espera"
	timer_ataque.wait_time = 1.0 / velocidad_ataque
	timer_ataque.one_shot = true
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)
	add_child(timer_ataque)

func _physics_process(_delta: float) -> void:
	# Ataca automáticamente e infinitamente mientras haya enemigos en el radio
	if puede_atacar and enemigos_al_alcance:
		var objetivo = seleccionar_objetivo()
		if objetivo:
			atacar(objetivo)

func seleccionar_objetivo() -> Node2D:
	var mas_cercano: Node2D = null
	var distancia_minima = INF
	
	for enemigo in enemigos_al_alcance:
		if is_instance_valid(enemigo):
			var dist = global_position.distance_to(enemigo.global_position)
			if dist < distancia_minima:
				distancia_minima = dist
				mas_cercano = enemigo
	return mas_cercano

# Lógica base del ataque infinito
func atacar(objetivo: Node2D) -> void:
	puede_atacar = false
	timer_ataque.start() # Bloquea el próximo frame hasta que pase la fracción de segundo correspondiente

func _on_timer_ataque_timeout() -> void:
	puede_atacar = true # Habilita inmediatamente el siguiente ataque de la ráfaga

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		enemigos_al_alcance.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body in enemigos_al_alcance:
		enemigos_al_alcance.erase(body)
