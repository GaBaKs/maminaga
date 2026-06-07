extends Node
var nivel_a_cargar: String
signal jugador_murio(yamurio:bool)
signal jugador_revivio
signal partida_ganada

#cuando tengamos mas enemigos, hay que precargarlos todos aca con ,
var enemigosBosque = {
	"Jabali": preload("res://escenas/enemigos/jabali.tscn"),
	"Planta": preload("res://escenas/enemigos/planta.tscn"),
	"Slime": preload("res://escenas/enemigos/slime.tscn")
}

var enemigosOscuro = {
	"Vampiro": preload("res://escenas/enemigos/vampiro.tscn"),
	"Slime_Oscuro": preload("res://escenas/enemigos/slime_oscuro.tscn"),
	"Orco_Oscuro": preload("res://escenas/enemigos/orco_oscuro.tscn")
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
	get_tree().paused = true
	
	if referencia_jugador:
		# SUMAR ALMAS
		PlayerData.almas += referencia_jugador.almas_en_partida
		
		# SUMAR MINERALES
		for tipo in referencia_jugador.minerales_en_partida.keys():
			PlayerData.minerales[tipo] += referencia_jugador.minerales_en_partida[tipo]
			
		# GUARDAR LOS CAMBIOS
		PlayerData.guardar_datos() # Asegurate que se llame así en tu script
		
	emit_signal("partida_ganada")
