extends Node2D

@export var escena_gema: PackedScene
@export var spawn_distancia_min: float = 400.0
@export var spawn_distancia_max: float = 600.0
@export var intentos_maximos: int = 10

@onready var foreground = $Foreground

var dificultad := 1

func _ready() -> void:
	
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	$EnemyTimer.timeout.connect(_on_enemy_timer_timeout)
	print("Inicia el mapa en dificultad: ", Global.dificultad_actual)
	$EnemyTimer.wait_time = 0.5#ajustes["spawn_rate"]
	$EnemyTimer.start()
	generar_minerales_por_dificultad()

func _on_enemy_timer_timeout():
	var jugador = Global.referencia_jugador
	if not is_instance_valid(jugador):
		return

	var punto = buscar_punto_spawn(jugador.global_position)
	print("Punto: ", punto)
	if punto == null:
		return

	var escena = Global.enemigos.values().pick_random()
	var nuevo_enemigo = escena.instantiate()
	add_child(nuevo_enemigo)
	nuevo_enemigo.global_position = punto  # ← global_position en lugar de position
	print("Enemigo spawneado en: ", punto)
	
func buscar_punto_spawn(origen: Vector2) -> Variant:
	for i in range(intentos_maximos):
		var angulo = randf() * TAU
		var distancia = randf_range(spawn_distancia_min, spawn_distancia_max)
		var candidato = origen + Vector2(cos(angulo), sin(angulo)) * distancia

		if not _dentro_del_mapa(candidato):
			continue
		if _hay_colision(candidato):
			continue

		return candidato

	return null

func _dentro_del_mapa(pos: Vector2) -> bool:
	var celda = foreground.local_to_map(foreground.to_local(pos))
	var tile = foreground.get_cell_source_id(celda)
	return tile != -1

func _hay_colision(pos: Vector2) -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 1
	query.exclude = [Global.referencia_jugador.get_rid()]
	var resultado = space.intersect_point(query)
	for r in resultado:
		if not r["collider"].is_in_group("enemigo"):
			return true
	return false

func generar_minerales_por_dificultad():
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	var multiplicador = ajustes["multiplicador_minerales"]
	var puntos_disponibles = $PuntosDeMinerales.get_children()
	puntos_disponibles.shuffle()
	var cantidad_base = 5
	var cantidad_a_spawnear = min(int(cantidad_base * multiplicador), puntos_disponibles.size())
	for i in range(cantidad_a_spawnear):
		var punto = puntos_disponibles[i]
