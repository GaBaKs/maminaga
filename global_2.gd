extends Node

var nivel_a_cargar: String

# --- Variables de Navegación y Configuración ---
var mapa_seleccionado: String = "" # Ejemplo: "res://mapas/bosque.tscn"
var dificultad_actual: int = 1    # 1: Fácil, 2: Medio, 3: Difícil
var skin_equipada: String = "default"
var referencia_jugador: CharacterBody2D
var cartel_interfaz: CanvasLayer 


# --- SISTEMA DE MINERALES Y ECONOMÍA (BANCO) ---
var minerales_tipo_1: int = 0 # Gema Roja (ej. Bosque)
var minerales_tipo_2: int = 0 # Gema Azul (ej. Hielo)
var minerales_tipo_3: int = 0 # Gema Verde (ej. Desierto)
var almas_totales: int = 0

# --- CONTADORES DE LA PARTIDA ACTUAL ---
var minerales_partida: int = 0 
var almas_partida: int = 0 # Cambiado de 'almas' a 'almas_partida' para consistencia

# --- CONFIGURACIÓN DE MAPAS Y RECOMPENSAS ---
# Aquí definimos qué gema da cada mapa para que el sistema sea automático
var configuracion_mapas = {
	"bosque": "res://mapas/bosque.tscn",
	"hielo": "res://mapas/hielo.tscn",
	"desierto": "res://mapas/desierto.tscn"
}

# --- SISTEMA DE SKINS ---
var todas_las_skins = {
	"default": "res://nyan_default.png",
	"ninja": "res://nyan_ninja.png",
	"gold": "res://nyan_gold.png"
}
var skins_desbloqueadas = ["default"] 

func desbloquear_skin(id: String):
	if not skins_desbloqueadas.has(id):
		skins_desbloqueadas.append(id)

func obtener_ruta_skin_actual() -> String:
	return todas_las_skins[skin_equipada]

# --- LÓGICA DE PARTIDA ---

func sumar_minerales(cantidad):
	minerales_partida += cantidad
	print("Recolectado en partida: ", minerales_partida)

func sumar_almas(cantidad):
	almas_partida += cantidad

func finalizar_partida(victoria: bool):
	get_tree().paused = true
	
	if cartel_interfaz != null:
		cartel_interfaz.mostrar_cartel() 
	else:
		print("ERROR: Cartel no registrado")

	if victoria:
		# 1. Identificar qué tipo de gema corresponde al mapa actual
		var tipo = 1 # Por defecto
		if configuracion_mapas.has(mapa_seleccionado):
			tipo = configuracion_mapas[mapa_seleccionado]["tipo_gema"]
		
		# 2. Sumar al acumulador correcto
		match tipo:
			1: minerales_tipo_1 += minerales_partida
			2: minerales_tipo_2 += minerales_partida
			3: minerales_tipo_3 += minerales_partida
		
		almas_totales += almas_partida
		print("¡Victoria! Gema Tipo ", tipo, " guardada. Almas totales: ", almas_totales)
	else:
		print("Derrota. Se perdieron los recursos de la partida.")
	
	# 3. Resetear contadores de partida
	minerales_partida = 0
	almas_partida = 0

# --- DIFICULTAD ---
var ajustes_dificultad = {
	1: {"spawn_rate": 2.5, "multiplicador_minerales": 1.0},
	2: {"spawn_rate": 1.5, "multiplicador_minerales": 1.5},
	3: {"spawn_rate": 0.8, "multiplicador_minerales": 2.5}
}

func obtener_multiplicador_enemigos():
	return ajustes_dificultad[dificultad_actual]["spawn_rate"]

func obtener_multiplicador_gemas():
	return ajustes_dificultad[dificultad_actual]["multiplicador_minerales"]
