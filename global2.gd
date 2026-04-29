extends Node

# Esta variable almacenará la ruta de la escena que queremos cargar
# Se inicializa vacía y se llena cuando pulsas el botón de "Jugar"
var nivel_a_cargar: String = ""

# Aquí también podrías guardar la dificultad más adelante
var dificultad_seleccionada: int = 1
var minerales: int = 0
var almas: int = 0
var skin_actual: String = "default"
#patron singleton aplicado p los minerales y almas
func sumar_minerales(cantidad):
	minerales += cantidad
	print("Ahora tenés: ", minerales)
var referencia_jugador: CharacterBody2D
