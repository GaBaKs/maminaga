extends Node

# Estas variables no se van a borrar nunca (variables globales)
var minerales: int = 0
var almas: int = 0
var skin_actual: String = "default"
#patron singleton aplicado p los minerales y almas
func sumar_minerales(cantidad):
	minerales += cantidad
	print("Ahora tenés: ", minerales)
var referencia_jugador: CharacterBody2D
