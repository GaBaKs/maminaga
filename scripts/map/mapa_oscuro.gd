extends Node2D

@export var tipos_de_minerales: Array[PackedScene] = [preload("res://escenas/mapas/mineral_1.tscn"),preload("res://escenas/mapas/mineral_2.tscn"),preload("res://escenas/mapas/mineral_3.tscn")]
@export var spawn_distancia_min: float = 400.0
@export var spawn_distancia_max: float = 600.0
@export var intentos_maximos: int = 10

@onready var foreground = $Foreground

var dificultad := 1

func _ready() -> void:
	
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	$EnemyTimer.timeout.connect(_on_enemy_timer_timeout)
	print("Inicia el mapa en dificultad: ", Global.dificultad_actual)
	$EnemyTimer.wait_time = Global.obtener_multiplicador_enemigos()
	$EnemyTimer.start()
	for nodo in get_tree().get_nodes_in_group("jugador"):
		print(nodo.name, " - ", nodo.get_class(), " - ", nodo.get_path())
	generar_minerales_por_dificultad()
@export var tipos_de_enemigos: Array[PackedScene]
func _on_enemy_timer_timeout():
	var jugador = Global.referencia_jugador
	if not is_instance_valid(jugador):
		return

	var punto = buscar_punto_spawn(jugador.global_position)
	if punto == null:
		return

	var escena = Global.enemigosOscuro.values().pick_random()
	var nuevo_enemigo = escena.instantiate()
	add_child(nuevo_enemigo)
	nuevo_enemigo.global_position = punto  # ← global_position en lugar de position
	
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
	print("--- INICIANDO SPAWN MINERALES ---")
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador:
		print("-> EL JUGADOR ESTA EN: ", jugador.global_position)
	
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	var multiplicador = ajustes["multiplicador_minerales"]
	
	# Verificamos que el nodo carpeta exista
	if not has_node("PuntosDeMinerales"):
		print("ERROR: No existe el nodo 'PuntosDeMinerales' en el mapa.")
		return
		
	var puntos_disponibles = $PuntosDeMinerales.get_children()
	print("1. Puntos encontrados en el mapa: ", puntos_disponibles.size())
	
	if puntos_disponibles.is_empty():
		print("ERROR: La carpeta PuntosDeMinerales no tiene ningún Marker2D adentro.")
		return
		
	puntos_disponibles.shuffle()
	var cantidad_base = 5
	var cantidad_a_spawnear = min(int(cantidad_base * multiplicador), puntos_disponibles.size())
	print("2. Vetas a spawnear según la dificultad: ", cantidad_a_spawnear)
	
	print("3. Tipos de minerales cargados en el array: ", tipos_de_minerales.size())
	if tipos_de_minerales.is_empty():
		print("ERROR: El Array tipos_de_minerales está vacío. ¡Te faltó cargarlos en el Inspector!")
		return
		
	var gemas_creadas = 0
	for i in range(cantidad_a_spawnear):
		var punto = puntos_disponibles[i]
		
		for escena_mineral in tipos_de_minerales:
			if escena_mineral != null:
				var nuevo_mineral = escena_mineral.instantiate()
				var offset_x = randf_range(-20.0, 20.0)
				var offset_y = randf_range(-20.0, 20.0)
				
				nuevo_mineral.global_position = punto.global_position + Vector2(offset_x, offset_y)
				print("Gema spawneada en: ", nuevo_mineral.global_position)
				add_child(nuevo_mineral)
				gemas_creadas += 1
				
	print("¡Éxito! Se spawnearon un total de ", gemas_creadas, " minerales.")
	print("--- FIN SPAWN MINERALES ---")
