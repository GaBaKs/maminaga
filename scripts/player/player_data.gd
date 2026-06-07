extends Node

#Script para almacenar y traer informacion del jugador mediante archivos Json

const ruta = "user://save.json"


# DATOS DEL JUGADOR

var nivel = 1
var experiencia = 0
var puntos_habilidad = 10
var experiencia_max = 100

var vida = 100
var danio = 10
var velocidad_ataque = 1.0
var regen_vida = 1.0
var armadura = 0

# MONEDAS

var minerales = {
	"mineral1": 100,
	"mineral2": 100,
	"mineral3": 100
}
var almas = 0

# SKINS

var todas_las_skins = {
	"default": "res://nyan_default.png",
	"ninja": "res://nyan_ninja.png",
	"gold": "res://nyan_gold.png"
}
var skins_desbloqueadas = ["default"] 

func desbloquear_skin(id: String):
	if not skins_desbloqueadas.has(id):
		skins_desbloqueadas.append(id)

var skin_actual = "default"

# INVENTARIO

var armas_compradas = ["espada"]
var arma_equipada = "espada"
var arma_escena : PackedScene
var armas_disponibles = {
	"pistola": preload("res://escenas/armas/pistola.tscn"),
	"espada": preload("res://escenas/armas/espada.tscn")
}



func _ready():
	cargar_datos()
	pass

func guardar_datos():

	var datos = {
		"jugador": {
			"nivel": nivel,
			"experiencia": experiencia,
			"experiencia_max": experiencia_max,
			"puntos_habilidad": puntos_habilidad,

			"estadisticas": {
				"vida": vida,
				"danio": danio,
				"velocidad_ataque": velocidad_ataque,
				"regen_vida": regen_vida,
				"armadura": armadura
			}
		},

		"monedas": {
			"minerales": minerales,
			"almas": almas
		},

		"skins": {
			"skin_actual": skin_actual,
			"skins_desbloqueadas": skins_desbloqueadas
		},

		"inventario": {
			"armas_compradas": armas_compradas,
			"arma_equipada": arma_equipada
		}
	}
	
	var archivo = FileAccess.open(ruta, FileAccess.WRITE)

	archivo.store_string(
		JSON.stringify(datos, "\t")
	)

	print("Partida guardada")

func cargar_datos():

	if not FileAccess.file_exists(ruta):
		print("No existe save, colocando valores default al personaje")
		guardar_datos()
		return

	var archivo = FileAccess.open(ruta, FileAccess.READ)

	var texto = archivo.get_as_text()

	var datos = JSON.parse_string(texto)

	if datos == null:
		print("Error al leer save")
		return

	# =========================
	# JUGADOR
	# =========================

	nivel = datos["jugador"]["nivel"]
	experiencia = datos["jugador"]["experiencia"]
	experiencia_max = datos["jugador"]["experiencia_max"]
	puntos_habilidad=datos["jugador"]["puntos_habilidad"]
	vida = datos["jugador"]["estadisticas"]["vida"]
	danio = datos["jugador"]["estadisticas"]["danio"]
	velocidad_ataque = datos["jugador"]["estadisticas"]["velocidad_ataque"]
	regen_vida = datos["jugador"]["estadisticas"]["regen_vida"]
	armadura = datos["jugador"]["estadisticas"]["armadura"]

	# =========================
	# MONEDAS
	# =========================

	minerales = datos["monedas"]["minerales"]
	almas = datos["monedas"]["almas"]

	# =========================
	# SKINS
	# =========================

	skin_actual = datos["skins"]["skin_actual"]

	skins_desbloqueadas = datos["skins"]["skins_desbloqueadas"]

	# =========================
	# INVENTARIO
	# =========================

	armas_compradas = datos["inventario"]["armas_compradas"]
	arma_equipada = datos["inventario"]["arma_equipada"]

	print("Partida cargada")

#func sumar_minerales(tipomineral, cantidad):
#
#	#Por ahora hardcodeado hay que separar por tipo de mineral
#	minerales[tipomineral]+=cantidad

func subir_nivel():
	nivel+=1
	experiencia=0
	experiencia_max=experiencia_max*1.15
	puntos_habilidad+=1
	print("Subio de nivel!")

func equipar_arma(id_arma: String):
	if armas_compradas.has(id_arma):
		arma_equipada = id_arma
		arma_escena=armas_disponibles[id_arma]
		print("Arma equipada para la partida: ", id_arma)
		guardar_datos()
