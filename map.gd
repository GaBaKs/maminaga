extends Node2D

# 1. Arrastrá tu escena enemigo.tscn a esta casilla en el inspector 
@export var escena_enemigo: PackedScene 
@export var escena_gema: PackedScene
var dificultad := 1

func _on_enemy_timer_timeout():
	# 2. Obtenemos la lista de todos los puntosDeSpawn que pusiste
	var puntosDeSpawn = $PuntosDeSpawn.get_children()
	
	# Verificamos que la lista no esté vacía antes de seguir
	if puntosDeSpawn.size() > 0:
		var punto_aleatorio = puntosDeSpawn.pick_random()
		
		# Verificamos que la escena esté asignada en el Inspector
		if escena_enemigo:
			var nuevo_enemigo = escena_enemigo.instantiate()
			nuevo_enemigo.position = punto_aleatorio.position
			add_child(nuevo_enemigo)
		else:
			print("Error: enemigo.tscn no esta en el Inspector del mapa")
	else:
		print("Error: El nodo puntosDeSpawn no tiene hijos!")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# 2. Usar ajustes_dificultad (el nombre del diccionario)
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	print(ajustes)
	$EnemyTimer.wait_time = ajustes["spawn_rate"] 
	$EnemyTimer.start()
	
	# Configuramos el Timer (asegurate que el nodo se llame spawn_timer o enemy_timer)
	if has_node("spawn_timer"):
		$spawn_timer.wait_time = ajustes["spawn_rate"]
		$spawn_timer.start()
	
	# ¡No te olvides de llamar a la función de los minerales!
	generar_minerales_por_dificultad()

	print("Inicia el mapa en dificultad: ", Global.dificultad_actual)
	
func generar_minerales_por_dificultad():
	# Obtenemos los ajustes de Global2
	var ajustes = Global.ajustes_dificultad[Global.dificultad_actual]
	var multiplicador = ajustes["multiplicador_minerales"]
	
	# Supongamos que tenés tus Marker2D dentro de un nodo llamado "MineralSpawns"
	var puntos_disponibles = $PuntosDeMinerales.get_children()
	puntos_disponibles.shuffle() # Mezclamos para que no siempre aparezcan en los mismos
	
	# Calculamos cuántos puntos usar (ej: 5 puntos base * 2.5 de dificultad = 12 puntos)
	var cantidad_base = 5 
	var cantidad_a_spawnear = min(int(cantidad_base * multiplicador), puntos_disponibles.size())
	
	for i in range(cantidad_a_spawnear):
		var punto = puntos_disponibles[i]
		var gema = escena_gema.instantiate()
		gema.position = punto.position
		add_child(gema)
	
	
