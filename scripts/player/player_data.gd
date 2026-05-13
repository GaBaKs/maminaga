extends Node

#Script para almacenar y traer informacion del jugador mediante archivos Json

const ruta = "user://save.json"


# DATOS DEL JUGADOR

var nivel = 1
var experiencia = 0

var vida = 100
var danio = 10
var velocidad_ataque = 1.0
var regen_vida = 1.0
var armadura = 0

# MONEDAS

var minerales = {
	"Amatista": 1,
	"Glacita": 0,
	"Rodonita": 1
}
var almas = 0

# SKINS

var skin_actual = "default"

var skins_desbloqueadas = [
	"default"
]

# INVENTARIO

var objetos_comprados = []

# En base a esta variable, cambiamos las stats del jugador
var objetos_equipados = []

func _ready():
	cargar_datos()

func guardar_datos():

	var datos = {
		"jugador": {
			"nivel": nivel,
			"experiencia": experiencia,

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
			"objetos_comprados": objetos_comprados,
			"objetos_equipados": objetos_equipados
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

	objetos_comprados = datos["inventario"]["objetos_comprados"]
	objetos_equipados = datos["inventario"]["objetos_equipados"]

	print("Partida cargada")

func sumar_minerales(cantidad):
	#Por ahora hardcodeado hay que separar por tipo de mineral
	minerales["Glacita"]+=1
