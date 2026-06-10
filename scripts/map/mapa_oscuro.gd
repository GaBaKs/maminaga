extends Node2D

@export var tipos_de_minerales: Array[PackedScene] = [preload("res://escenas/mapas/mineral_1.tscn"),preload("res://escenas/mapas/mineral_2.tscn"),preload("res://escenas/mapas/mineral_3.tscn")]
@export var tipos_de_enemigos: Array[PackedScene]

@export var spawn_distancia_min: float = 400.0
@export var spawn_distancia_max: float = 600.0
@export var intentos_maximos: int = 10

# Variables globales para el mapa
var tiempo_total_partida = 330.0 # 5.5 minutos
var tiempo_spawn_base = 2.0 # Valor por defecto

# Recordá cambiar "Foreground" por tu capa de piso real para que no spawneen invisibles
@onready var capa_suelo = $Foreground 

var dificultad := 1

func _ready() -> void:
	# 1. Definimos la velocidad base de aparición según la dificultad
	match Global.dificultad_actual:
		"facil":
			tiempo_spawn_base = 3.0
		"normal":
			tiempo_spawn_base = 2.0
		"dificil":
			tiempo_spawn_base = 1.0
			
	# Asignamos el tiempo al timer
	$EnemyTimer.wait_time = tiempo_spawn_base
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	$EnemyTimer.timeout.connect(_on_enemy_timer_timeout)
	
	print("Inicia el mapa en dificultad: ", Global.dificultad_actual)
	
	# Ojo acá: antes sobreescribías el wait_time que acababas de calcular
	# Lo dejo como estaba en tu lógica, pero revisalo si spawnean muy rápido o lento
	$EnemyTimer.wait_time = Global.obtener_multiplicador_enemigos()
	$EnemyTimer.start()
	
	for nodo in get_tree().get_nodes_in_group("jugador"):
		print(nodo.name, " - ", nodo.get_class(), " - ", nodo.get_path())
		
	generar_minerales_por_dificultad()

func _on_enemy_timer_timeout():
	# CORRECCIÓN TIMER: Validamos que el Timer exista antes de pedirle el time_left
	var tiempo_restante = 0.0
	if has_node("Timer_supervivencia") and $Timer_supervivencia != null:
		tiempo_restante = $Timer_supervivencia.time_left
		
	var tiempo_transcurrido = tiempo_total_partida - tiempo_restante
	var minuto_actual = int(tiempo_transcurrido / 60.0)
	
	var jugador = Global.referencia_jugador
	if not is_instance_valid(jugador):
		return

	var punto = buscar_punto_spawn(jugador.global_position)
	if punto == null:
		return

	# CORRECCIÓN ENEMIGOS: Evitar crasheo por diccionario vacío
	var valores_enemigos = Global.enemigosOscuro.values()
	if valores_enemigos.is_empty():
		return
		
	var escena = valores_enemigos.pick_random()
	if escena == null:
		return
		
	var nuevo_enemigo = escena.instantiate()
	add_child(nuevo_enemigo)
	nuevo_enemigo.global_position = punto 
	
	# 4. Aumentamos la vida del enemigo según el minuto
	var vida_base = 100.0
	var multiplicador_vida = 1.0 + (minuto_actual * 0.5) 
	nuevo_enemigo.vida_enemigo = vida_base * multiplicador_vida
	
	# 5. Aceleramos el siguiente spawn
	var reduccion_tiempo = minuto_actual * 0.15 
	var nuevo_tiempo_espera = tiempo_spawn_base - reduccion_tiempo  
	$EnemyTimer.wait_time = max(0.2, nuevo_tiempo_espera)

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
	var celda = capa_suelo.local_to_map(capa_suelo.to_local(pos))
	var tile = capa_suelo.get_cell_source_id(celda)
	return tile != -1

func _hay_colision(pos: Vector2) -> bool:
	# CORRECCIÓN COLISIÓN: Evitar crasheo si Mami es derrotada
	if not is_instance_valid(Global.referencia_jugador):
		return true 
		
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
	
	if not has_node("PuntosDeMinerales"):
		print("ERROR: No existe el nodo 'PuntosDeMinerales'.")
		return
		
	var puntos_disponibles = $PuntosDeMinerales.get_children()
	
	if puntos_disponibles.is_empty():
		return
		
	puntos_disponibles.shuffle()
	var cantidad_base = 5
	var cantidad_a_spawnear = min(int(cantidad_base * multiplicador), puntos_disponibles.size())
	
	if tipos_de_minerales.is_empty():
		return
		
	var gemas_creadas = 0
	
	# CORRECCIÓN MINERALES: Un solo mineral por punto para no crashear
	for i in range(cantidad_a_spawnear):
		var punto = puntos_disponibles[i]
		var escena_mineral = tipos_de_minerales.pick_random() 
		
		if escena_mineral != null:
			var nuevo_mineral = escena_mineral.instantiate()
			add_child(nuevo_mineral) 
			
			var offset_x = randf_range(-20.0, 20.0)
			var offset_y = randf_range(-20.0, 20.0)
			nuevo_mineral.global_position = punto.global_position + Vector2(offset_x, offset_y)
			
			gemas_creadas += 1
				
	print("--- FIN SPAWN MINERALES ---")

func _on_timer_supervivencia_timeout():
	Global.ganar_partida()

func _on_timer_locura_timeout() -> void:
	print("¡MODO LOCURA ACTIVADO! Sobrevive 30 segundos más.")
	var timer_enemigos = $EnemyTimer
	timer_enemigos.wait_time = 0.1
	
	# CORRECCIÓN UI: Validar que la interfaz exista antes de mostrarla
	if has_node("CanvasLayer/LabelLocura"):
		$CanvasLayer/LabelLocura.show()
		if has_node("CanvasLayer/LabelLocura/TimerOcultarLocura"):
			$CanvasLayer/LabelLocura/TimerOcultarLocura.start()
			
	var extraccion = $extraccion
	var extraccion2 = $extraccion2
	if extraccion and extraccion2:
		extraccion.show()
		extraccion2.show()
		extraccion.monitoring = true
		extraccion2.monitoring = true

func _on_timer_ocultar_locura_timeout() -> void:
	if has_node("CanvasLayer/LabelLocura"):
		$CanvasLayer/LabelLocura.hide()
