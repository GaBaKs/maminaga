extends Node2D

@export var mineral_escena: PackedScene 
@export_range(0, 100) var probabilidad: int = 50
func _ready():
	# Usamos call_deferred para esperar a que Godot termine de cargar la escena actual
	call_deferred("_intentar_spawn")
#func _ready():
	# Generamos un número al azar entre 0 y 100
#	var azar = randi() % 101
	
#	if azar <= probabilidad:
#		spawnear_mineral()
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
#func spawnear_mineral():
#	if mineral_escena:
#		var instancia = mineral_escena.instantiate()
##		add_child(instancia)
#		instancia.global_position = global_position 
