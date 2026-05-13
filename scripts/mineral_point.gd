extends Node2D

@export var mineral_escena: PackedScene 
@export_range(0, 100) var probabilidad: int = 50
func _ready() -> void:
	pass

func generar_minerales_por_dificultad(multiplicador):
	# Buscamos tus Marker2D de minerales
	var puntos_disponibles = $PuntosDeMinerales.get_children()
	puntos_disponibles.shuffle()
	
	# Calculamos cuántos spawnean según la dificultad
	var cantidad_base = 5 
	var cantidad_a_spawnear = min(int(cantidad_base * multiplicador), puntos_disponibles.size())
	
	for i in range(cantidad_a_spawnear):
		var punto = puntos_disponibles[i]
		if mineral_escena:
			var gema = mineral_escena.instantiate()
			gema.position = punto.position
			add_child(gema)
			
#este ya no lo estoy usando
func _intentar_spawn():
	var azar = randi() % 101
	if azar <= probabilidad:
		if mineral_escena:
			var instancia = mineral_escena.instantiate()
			# Agregamos la gema al padre del marcador (el contenedor en el mapa)
			get_parent().add_child(instancia)
			instancia.global_position = global_position
		else:
			print("ERROR: No arrastraste la escena de minerales al Inspector del MineralPoint")
