extends Node
var nivel_a_cargar: String
signal jugador_murio(yamurio:bool)
signal jugador_revivio
signal partida_ganada

#cuando tengamos mas enemigos, hay que precargarlos todos aca con ,
var enemigosBosque = {
	"Goblin": preload("res://escenas/enemigos/enemigo.tscn"),
	"enemigo2": preload("res://escenas/enemigos/slime.tscn"),
	"enemigo3": preload("res://escenas/enemigos/orco.tscn")
}

var enemigosOscuro = {
	"Vampiro": preload("res://escenas/enemigos/vampiro.tscn")
}

var enemigosNieve = {
	"Goblin": preload("res://escenas/enemigos/enemigo.tscn"),
	"enemigo2": preload("res://escenas/enemigos/slime.tscn"),
	"enemigo3": preload("res://escenas/enemigos/orco.tscn")
}
# --- Variables de Navegación y Configuración ---
var mapa_seleccionado: String = "" # Ejemplo: "res://mapas/bosque.tscn"
var dificultad_actual: int = 1    # 1: Fácil, 2: Medio, 3: Difícil
var skin_equipada: String = "default"
var referencia_jugador: CharacterBody2D
var cartel_interfaz: CanvasLayer 

var mult_dificultad = [1, 1.5, 2]

# --- CONFIGURACIÓN DE MAPAS Y RECOMPENSAS ---
# Aquí definimos qué gema da cada mapa para que el sistema sea automático
var configuracion_mapas = {
	"bosque": "res://mapas/bosque.tscn",
	"hielo": "res://mapas/hielo.tscn",
	"desierto": "res://mapas/desierto.tscn"
}


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
	
func ganar_partida():
	get_tree().paused = true # Detiene el tiempo
	
	if referencia_jugador != null:
		# 1. Pasamos las cosas de la mochila del jugador al Banco (PlayerData)
		PlayerData.almas_totales += referencia_jugador.almas
		
		for key in referencia_jugador.minerales.keys():
			PlayerData.minerales[key] += referencia_jugador.minerales[key]
			
		# 2. Persistimos los datos
		PlayerData.save_data()
	
	# 3. Llamamos al cartel de Victoria
	emit_signal("partida_ganada")
