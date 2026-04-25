extends Node2D

const goblin = preload("res://escenas//goblin.tscn")
var contenedor_enemigos
var enemigos = [goblin]

#manejo de spawn de enemigos
var tiempo_total := 0.0
var dificultad := 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("inicia el mapa")
	
	spawneaEnemigo()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tiempo_total += delta
	pass

func spawneaEnemigo():
	var escena_enemigo = enemigos.pick_random()
	var enemigo = escena_enemigo.instantiate()
	add_child(enemigo)
