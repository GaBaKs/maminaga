extends Node2D

# 1. Arrastrá tu escena enemigo.tscn a esta casilla en el inspector 
@export var escena_enemigo: PackedScene 

func _on_enemy_timer_timeout():
	# 2. Obtenemos la lista de todos los puntos de spawn que pusiste
	var puntos = $PuntosDeSpawn.get_children()
	
	# Verificamos que la lista no esté vacía antes de seguir
	if puntos.size() > 0:
		var punto_aleatorio = puntos.pick_random()
		
		# Verificamos que la escena esté asignada en el Inspector
		if escena_enemigo:
			var nuevo_enemigo = escena_enemigo.instantiate()
			nuevo_enemigo.global_position = punto_aleatorio.global_position
			add_child(nuevo_enemigo)
		else:
			print("Error: enemigo.tscn no esta en el Inspector del mapa")
	else:
		print("Error: El nodo PuntosDeSpawn no tiene hijos!")
	
	# 3. Elegimos uno al azar de la lista
	var punto_aleatorio = puntos.pick_random()
	
	# 4. "Fabricamos" (instanciamos) un nuevo enemigo 
	var nuevo_enemigo = escena_enemigo.instantiate()
	
	# 5. Lo ubicamos en la posición del marcador elegido
	nuevo_enemigo.global_position = punto_aleatorio.global_position
	
	# 6. Lo añadimos al mapa para que empiece a perseguir al jugador [cite: 3, 31]
	add_child(nuevo_enemigo)
