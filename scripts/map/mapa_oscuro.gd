extends Node2D
@export var tipos_de_minerales: Array[PackedScene] = [preload("res://escenas/mapas/mineral_1.tscn"),preload("res://escenas/mapas/mineral_2.tscn"),preload("res://escenas/mapas/mineral_3.tscn")]
@export var spawn_distancia_min: float = 400.0
@export var spawn_distancia_max: float = 600.0
@export var intentos_maximos: int = 20
@onready var label_timer = $Joystick/timerarriba
# Variables globales para el mapa
var tiempo_total_partida = 30.0 # 5.5 minutos
var tiempo_spawn_base = 2.0 # Valor por defecto

@onready var foreground = $Foreground

var dificultad := 1

func _ready() -> void:
	# 1. Definimos la velocidad base de aparición según la dificultad
	match Global.dificultad_actual:
		1: # Fácil
			tiempo_spawn_base = 3.0 # Un enemigo cada 3 segundos
		2: # Normal
			tiempo_spawn_base = 2.0 # Un enemigo cada 2 segundos
		3: # Difícil
			tiempo_spawn_base = 1.0 # Un enemigo por segundo
			
	# Asignamos el tiempo al timer
	$EnemyTimer.wait_time = tiempo_spawn_base
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	$EnemyTimer.timeout.connect(_on_enemy_timer_timeout)
	print("Inicia el mapa en dificultad: ", Global.dificultad_actual)
	$EnemyTimer.wait_time = Global.obtener_multiplicador_enemigos()
	$EnemyTimer.start()
	for nodo in get_tree().get_nodes_in_group("jugador"):
		print(nodo.name, " - ", nodo.get_class(), " - ", nodo.get_path())
	generar_minerales_por_dificultad()
	
func _process(delta):
	# Verificamos que el timer esté corriendo y que el label exista
	if $Timer_supervivencia.time_left > 0:
		var tiempo_restante = $Timer_supervivencia.time_left
		
		# Matemática para formato reloj
		var minutos = int(tiempo_restante) / 60
		var segundos = int(tiempo_restante) % 60
		
		# Actualizamos el texto en pantalla
		label_timer.text = "%02d:%02d" % [minutos, segundos]
	else:
		label_timer.text = "00:00"
	
@export var tipos_de_enemigos: Array[PackedScene]
func _on_enemy_timer_timeout():
	# 2. Calculamos el minuto actual
	# Restamos el tiempo que le queda al timer del tiempo total para saber cuánto pasó
	var tiempo_transcurrido = tiempo_total_partida - $Timer_supervivencia.time_left
	var minuto_actual = int(tiempo_transcurrido / 60.0) # Esto nos dará 0, 1, 2, 3, 4 o 5
	
	var jugador = Global.referencia_jugador
	if not is_instance_valid(jugador):
		return

	var punto = buscar_punto_spawn(jugador.global_position)
	if punto == null:
		return

	var escena = Global.enemigosOscuro.values().pick_random()
	var nuevo_enemigo = escena.instantiate()
	add_child(nuevo_enemigo)
	nuevo_enemigo.global_position = punto 
	# 4. Aumentamos la vida del enemigo según el minuto
	var vida_base = 100.0
	var multiplicador_vida = 1.0 + (minuto_actual * 0.2) 
	nuevo_enemigo.vida_enemigo = vida_base * multiplicador_vida
	
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
				
				# 1. PRIMERO LO AGREGAMOS AL MAPA (Nace)
				add_child(nuevo_mineral) 
				
				# 2. DESPUÉS LE DECIMOS A DÓNDE IR
				var offset_x = randf_range(-20.0, 20.0)
				var offset_y = randf_range(-20.0, 20.0)
				nuevo_mineral.global_position = punto.global_position + Vector2(offset_x, offset_y)
				
				gemas_creadas += 1
				
	print("¡Éxito! Se spawnearon un total de ", gemas_creadas, " minerales.")
	print("--- FIN SPAWN MINERALES ---")
# Conectá la señal timeout de tu TimerSupervivencia
func _on_timer_supervivencia_timeout():
	# Pasaron los 10 minutos
	Global.ganar_partida()


func _on_timer_locura_timeout() -> void:
	print("¡MODO LOCURA ACTIVADO! Sobrevive 30 segundos más.")
	
	# Buscamos el timer que genera a los enemigos
	# (Asegurate de que el nombre coincida con tu nodo real en la escena)
	var timer_enemigos = $EnemyTimer
	
	# Bajamos el tiempo de espera al mínimo para que spawneen rapidísimo
	# Por ejemplo, 0.1 o 0.2 segundos entre cada enemigo
	timer_enemigos.wait_time = 0.1
	$CanvasLayer/LabelLocura.show()
	$CanvasLayer/LabelLocura/TimerOcultarLocura.start()
	var extraccion = $extraccion
	var extraccion2 = $extraccion2
	extraccion.show()
	extraccion2.show()
	extraccion.monitoring = true
	extraccion2.monitoring = true


func _on_timer_ocultar_locura_timeout() -> void:
	$CanvasLayer/LabelLocura.hide()
