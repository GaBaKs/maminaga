extends Node2D

const goblin = preload("res://Goblin.tscn")
var contenedor_enemigos
var enemigos = [goblin]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("inicia el mapa")
	spawneaEnemigo()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawneaEnemigo():
	var escena_enemigo = enemigos.pick_random()
	var enemigo = escena_enemigo.instantiate()
	add_child(enemigo)
