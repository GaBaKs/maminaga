
extends CharacterBody2D
class_name Jugador # Esto permite que otros scripts lo reconozcan como un tipo

# Atributos compartidos
@export var vida: float = 100.0
@export var velocidad: float = 200.0
@export var danio: float = 10.0

func recibir_danio(cantidad: float):
	vida -= cantidad
	if vida <= 0:
		morir()

func morir():
	# Lógica base (ej: efecto de partículas o sonido)
	queue_free()
