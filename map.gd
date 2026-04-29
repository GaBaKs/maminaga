extends Node2D

# 1. Arrastrá tu escena enemigo.tscn a esta casilla en el inspector 
@export var escena_enemigo: PackedScene 
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
	print("inicia el mapa")
	
	
