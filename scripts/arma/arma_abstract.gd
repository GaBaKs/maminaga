extends Node2D
class_name ArmaAbstract

signal enemigo_detectado(enemigo: Node2D)
signal enemigo_perdido(enemigo: Node2D)

@export var nombre_arma: String = "Arma Base"
@export var danio: float = 10.0
@export var velocidad_ataque: float = 2.0
@export var alcance_radio: float = 200.0
@export var distancia_al_jugador: float = 50.0

@onready var area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

var puede_atacar: bool = true
var enemigos_al_alcance: Array[Node2D] = []
var timer_ataque: Timer
var jugador: Node2D = null
var direccion_actual := Vector2.RIGHT

func _ready() -> void:
	jugador = Global.referencia_jugador

	if collision_shape and collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = alcance_radio

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

	timer_ataque = Timer.new()
	timer_ataque.wait_time = 1.0 / velocidad_ataque
	timer_ataque.one_shot = true
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)
	add_child(timer_ataque)

func _physics_process(_delta: float) -> void:
	_actualizar_posicion()
	print("Enemigos al alcance: ", enemigos_al_alcance.size())
	if puede_atacar and enemigos_al_alcance.size() > 0:
		var objetivo = seleccionar_objetivo()
		if objetivo:
			atacar(objetivo)

func _actualizar_posicion() -> void:
	if not is_instance_valid(jugador):
		return
	global_position = jugador.global_position + direccion_actual * distancia_al_jugador

func seleccionar_objetivo() -> Node2D:
	var mas_cercano: Node2D = null
	var distancia_minima = INF
	for enemigo in enemigos_al_alcance:
		if is_instance_valid(enemigo):
			var dist = jugador.global_position.distance_to(enemigo.global_position)
			if dist < distancia_minima:
				distancia_minima = dist
				mas_cercano = enemigo
	return mas_cercano

func atacar(objetivo: Node2D) -> void:
	puede_atacar = false
	timer_ataque.start()
	if is_instance_valid(objetivo):
		direccion_actual = (objetivo.global_position - jugador.global_position).normalized()
		aplicar_danio(objetivo)  # ← cada hija define esto

func aplicar_danio(objetivo: Node2D) -> void:
	pass  # la hija sobreescribe esto

func _on_timer_ataque_timeout() -> void:
	puede_atacar = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		enemigos_al_alcance.append(body)
		enemigo_detectado.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if body in enemigos_al_alcance:
		enemigos_al_alcance.erase(body)
		enemigo_perdido.emit(body)
