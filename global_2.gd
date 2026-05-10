extends Node

# --- Variables de Navegación y Configuración ---
var nivel_a_cargar: String = ""
var dificultad_seleccionada: int = 1
var skin_actual: String = "default"
var referencia_jugador: CharacterBody2D

# --- SISTEMA DE MINERALES Y ECONOMÍA ---
# Estas son las gemas totales acumuladas (para la tienda)
var minerales: int = 0 
# Estas son las gemas que vas agarrando EN LA PARTIDA actual
var minerales_partida: int = 0 

var almas: int = 0

# Referencia al cartel para no tener que buscarlo cada vez
var cartel_interfaz: CanvasLayer 

func jugador_murio():
	# Centralizamos la lógica de derrota [cite: 11]
	if cartel_interfaz:
		cartel_interfaz.mostrar(false) # false indica que es derrota
	else:
		print("Error: No se encontró la referencia del Cartel en Global")

# Esta función la llamaremos cuando termine el anuncio
func revivir_jugador():
	if referencia_jugador:
		referencia_jugador.vida = 400 # O tu vida máxima [cite: 25]
		referencia_jugador.barra_vida.value = 400
		referencia_jugador.set_physics_process(true)
		referencia_jugador.visible = true
		# No reseteamos minerales_partida porque el anuncio le permite seguir

# Función para cuando el mineral choca con el jugador
func sumar_minerales(cantidad):
	minerales_partida += cantidad
	print("Llevas recolectado en esta partida: ", minerales_partida)

# Función que llama el Cartel de Fin [cite: 173, 174]
func finalizar_partida(victoria: bool):
	get_tree().paused = true
	if cartel_interfaz != null:
		cartel_interfaz.mostrar_cartel() # Asegúrate que el nombre coincida
	else:
		print("ERROR: El cartel no está registrado en Global2")
	if victoria:
		minerales += minerales_partida # Si gana, se suma al total [cite: 174]
		print("¡Victoria! Total guardado: ", minerales)
	else:
		print("Derrota. Se perdieron ", minerales_partida, " minerales.") # [cite: 173]
	
	minerales_partida = 0 # Siempre volvemos a cero para el próximo mapa

# Si todavía necesitas sumar almas (suponiendo que estas no se pierden)
func sumar_almas(cantidad):
	almas += cantidad
