extends Node

#Script para almacenar y traer informacion del jugador mediante archivos Json

# =========================
# DATOS DEL JUGADOR
# =========================

var nivel = 1
var experiencia = 0

var vida = 100
var danio = 10
var velocidad_ataque = 1.0

# =========================
# MONEDAS
# =========================

var minerales = 0
var almas = 0

# =========================
# SKINS
# =========================

var skin_actual = "default"

var skins_desbloqueadas = [
	"default"
]

# =========================
# INVENTARIO
# =========================
var objetos_comprados = []

#En base a esta variable, cambiamos las stats del jugador
var objetos_equipados = []


func guardar_datos():

	var datos = {
		"jugador": {
			"nivel": nivel,
			"experiencia": experiencia,

			"estadisticas": {
				"vida": vida,
				"danio": danio,
				"velocidad_ataque": velocidad_ataque
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
			"objetos_equipador": objetos_equipados
		}
	}

	var archivo = FileAccess.open("user://save.json", FileAccess.WRITE)

	archivo.store_string(
		JSON.stringify(datos, "\t")
	)

	print("Partida guardada")

func cargar_datos():

	if not FileAccess.file_exists("user://save.json"):
		print("No existe save, colocando valores default al personaje")
		#hay que hacer logica para que agarre los objetos default
		return

	var archivo = FileAccess.open("user://save.json", FileAccess.READ)

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
