# menu_principal.gd
extends Control

# --- Referencias a los labels de recursos ---
# Asegurate de que estas rutas de nodos ($...) coincidan exactamente con tu escena
@onready var label_minerales_1 = $SeccionSuperior/Gema1/Label
@onready var label_minerales_2 = $SeccionSuperior/Gema2/Label
@onready var label_minerales_3 = $SeccionSuperior/Gema3/Label
@onready var label_almas = $SeccionSuperior/Almas/Label

var indice_seleccionado = 0

func _ready():
	# Al entrar al menú, mostramos los datos del "banco"
	actualizar_ui_recursos()
	
	# Buscamos en qué posición de la lista de desbloqueadas está la equipada
	# para que las flechas empiecen desde donde lo dejó el usuario
	indice_seleccionado = Global.skins_desbloqueadas.find(Global.skin_equipada)
	if indice_seleccionado == -1: indice_seleccionado = 0 # Failsafe
	
	actualizar_pantalla()

func actualizar_ui_recursos():
	# Usamos los nombres exactos de las variables que creamos en el Global.gd
	label_minerales_1.text = str(Global.minerales_tipo_1)
	label_minerales_2.text = str(Global.minerales_tipo_2)
	label_minerales_3.text = str(Global.minerales_tipo_3)
	label_almas.text = str(Global.almas_totales)

# --- SISTEMA DE SKINS ---

func _on_button_next_pressed():
	# Ciclo infinito sobre las skins que el usuario YA TIENE
	indice_seleccionado = (indice_seleccionado + 1) % Global.skins_desbloqueadas.size()
	aplicar_cambio_skin()

func _on_button_prev_pressed():
	indice_seleccionado = (indice_seleccionado - 1 + Global.skins_desbloqueadas.size()) % Global.skins_desbloqueadas.size()
	aplicar_cambio_skin()

func aplicar_cambio_skin():
	# Guardamos la elección en el Global
	var id_skin = Global.skins_desbloqueadas[indice_seleccionado]
	Global.skin_equipada = id_skin
	actualizar_pantalla()
	
func actualizar_pantalla():
	# Cargamos la imagen desde el diccionario maestro del Global
	var ruta = Global.todas_las_skins[Global.skin_equipada]
	$SeccionCentral/TextureRect_skin.texture = load(ruta)

# --- SELECCIÓN DE MAPA Y DIFICULTAD ---

func _on_boton_Mapa1_pressed():
	# IMPORTANTE: Esta ruta debe existir en Global.configuracion_mapas
	Global.mapa_seleccionado = "res://mapas/bosque.tscn"
	# Aquí podrías abrir un panel de dificultad o ir directo:
	ir_al_juego()

func _on_boton_Mapa2_pressed():
	Global.mapa_seleccionado = "res://mapas/hielo.tscn"
	ir_al_juego()

func _on_boton_Mapa3_pressed():
	Global.mapa_seleccionado = "res://mapas/desierto.tscn"
	ir_al_juego()

func _on_dificultad_selected(index):
	# Si usas un OptionButton o botones: 0=Fácil, 1=Medio, 2=Difícil
	Global.dificultad_actual = index + 1
	print("Dificultad cambiada a: ", Global.dificultad_actual)

func ir_al_juego():
	# Antes de cambiar de escena, reseteamos los puntos de la partida anterior por seguridad
	Global.minerales_partida = 0
	Global.almas_partida = 0
	get_tree().change_scene_to_file("res://loading_screen.tscn")

# --- BOTONES DE TIENDA ---

func _on_shop_button_pressed():
	print("Abriendo tienda de skins...")

func _on_boton_mas_gema_pressed():
	print("Abriendo tienda de gemas/micropagos...")
