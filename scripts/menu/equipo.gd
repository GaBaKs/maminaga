extends Control

# Asegúrate de arrastrar tus botones aquí desde el panel de Nodos
@onready var btn_espada = $boton_espada
@onready var btn_arco = $boton_arco 
@onready var btn_hacha = $boton_hacha

@onready var boton_equipar_espada = $boton_equipar_espada
@onready var boton_equipar_arco = $boton_equipar_arco 
@onready var boton_equipar_hacha = $boton_equipar_hacha

# --- NUEVAS REFERENCIAS A LOS NODOS DE IMAGEN ---
@onready var img_espada = $espada
@onready var img_arco = $arco
@onready var img_hacha = $hacha

# --- RUTA DONDE ESTÁN GUARDADOS TUS SPRITES ---
# ¡IMPORTANTE: Cambiá esto por la ruta real de tu carpeta de imágenes!
# Asegurate de que termine con una barra "/"
const RUTA_SPRITES = "res://assets/arma/"

# Agregamos "madera" como el primer nivel base
const ORDEN_MATERIALES = ["madera", "amatista", "ruby", "agatha"]

# Aca van los costos de las armas
# Mapeamos los nombres nuevos a las variables originales de tu PlayerData
const MAPEO_MINERALES = {
	"amatista": "mineral1",
	"ruby": "mineral2",
	"agatha": "mineral3"
}

# --- VARIABLES PARA LOS CARTELES ---
var dialogo_confirmacion: ConfirmationDialog
var dialogo_advertencia: AcceptDialog 
var arma_en_tramite: String = ""
var material_en_tramite: String = ""
var moneda_en_tramite: String = "" # Puede ser "almas" o el nombre del mineral
var costo_en_tramite: int = 0

func _ready():
	boton_equipar_espada.pressed.connect(func(): _on_boton_equip_pressed("espada"))
	boton_equipar_arco.pressed.connect(func(): _on_boton_equip_pressed("arco")) 
	boton_equipar_hacha.pressed.connect(func(): _on_boton_equip_pressed("hacha"))
	compradas()

func compradas():
	# Evaluamos cada botón pasando el nodo del botón principal, el de equipar, LA IMAGEN, y el ID
	configurar_botones(btn_espada, boton_equipar_espada, img_espada, "espada")
	configurar_botones(btn_arco, boton_equipar_arco, img_arco, "arco")
	configurar_botones(btn_hacha, boton_equipar_hacha, img_hacha, "hacha")

func configurar_botones(btn_principal: Button, btn_equip: Button, nodo_img: TextureRect, id_arma: String):
	# Por defecto mostramos la imagen de madera si el arma aún no fue comprada
	var material_actual = "madera" 
	
	if PlayerData.armas_compradas.has(id_arma):
		material_actual = PlayerData.armas_compradas[id_arma]
		var indice_tier = ORDEN_MATERIALES.find(material_actual)
		
		# Forzamos la actualización visual de la UI usando show()
		btn_equip.show() 
		if PlayerData.arma_equipada["nombre"] == id_arma:
			btn_equip.text = "Equipado"
			btn_equip.disabled = true
		else:
			btn_equip.text = "Equipar"
			btn_equip.disabled = false
		
		if indice_tier < ORDEN_MATERIALES.size() - 1:
			btn_principal.show()
			var siguiente_material = ORDEN_MATERIALES[indice_tier + 1]
			btn_principal.text = "Mejorar a " + siguiente_material.capitalize()
		else:
			btn_principal.hide() # Usamos hide() en vez de visible = false
	else:
		btn_equip.hide()
		btn_principal.show()
		btn_principal.text = "Comprar"

	# --- NUEVA LÓGICA SEGURA PARA ACTUALIZAR LA IMAGEN ---
	# Construimos el nombre del archivo exacto (ej: "espada-madera.png")
	var nombre_archivo = id_arma + "-" + material_actual + ".png"
	var ruta_completa = RUTA_SPRITES + nombre_archivo
	
	# Cargamos la textura en una variable temporal
	var nueva_textura = load(ruta_completa)
	
	# Solo la aplicamos si Godot la encontró exitosamente
	if nueva_textura != null:
		nodo_img.texture = nueva_textura
	else:
		# Usamos printerr para que salga en rojo en el depurador y sea fácil de ver
		printerr("ERROR DE IMAGEN: Godot no encontró el sprite. Buscó exactamente esta ruta: ", ruta_completa)

func _on_boton_espada_pressed(): procesar_compra_mejora("espada")
func _on_boton_arco_pressed(): procesar_compra_mejora("arco") 
func _on_boton_hacha_pressed(): procesar_compra_mejora("hacha")

func _on_boton_equip_pressed(id_arma: String):
	# Si ya la tiene, la equipa
	PlayerData.equipar_arma(id_arma)
	# Refrescamos la interfaz para que los textos y colores cambien
	compradas() 

func procesar_compra_mejora(id_arma: String):
	# Ahora el primer nivel objetivo al no tener el arma es "madera"
	var material_objetivo = "madera" 
	
	if PlayerData.armas_compradas.has(id_arma):
		var material_actual = PlayerData.armas_compradas[id_arma]
		var indice_actual = ORDEN_MATERIALES.find(material_actual)
		material_objetivo = ORDEN_MATERIALES[indice_actual + 1]
		
	# Guardamos los datos de la transacción actual
	arma_en_tramite = id_arma
	material_en_tramite = material_objetivo
	
	# Asignamos precio según si es compra nueva o mejora
	if material_objetivo == "madera":
		moneda_en_tramite = "almas"
		if id_arma == "arco":
			costo_en_tramite = 30
		elif id_arma == "hacha":
			costo_en_tramite = 50
		else:
			costo_en_tramite = 0 # La espada ya la tiene de base
	else:
		# Si es una mejora, pide 2 del mineral correspondiente
		moneda_en_tramite = material_objetivo 
		costo_en_tramite = 2
	
	# Mostramos el cartel en lugar de comprar directamente
	mostrar_cartel_confirmacion()

func mostrar_cartel_confirmacion():
	# Si ya existía un cartel de antes, lo borramos para no acumular basura
	if dialogo_confirmacion != null:
		dialogo_confirmacion.queue_free()
		
	dialogo_confirmacion = ConfirmationDialog.new()
	dialogo_confirmacion.title = "Confirmar Transacción"
	
	var accion = "Comprar" if material_en_tramite == "madera" else "Mejorar a"
	dialogo_confirmacion.dialog_text = "¿Estás seguro que deseas " + accion + " " + arma_en_tramite.capitalize() + " " + material_en_tramite.capitalize() + "?\n\nCosto: " + str(costo_en_tramite) + " " + moneda_en_tramite.capitalize()
	
	dialogo_confirmacion.ok_button_text = "Aceptar"
	dialogo_confirmacion.cancel_button_text = "Cancelar"
	
	# Conectamos el botón de Aceptar a la ejecución real de la compra
	dialogo_confirmacion.confirmed.connect(_on_compra_aceptada)
	
	# Lo agregamos y lo mostramos en el centro
	add_child(dialogo_confirmacion)
	dialogo_confirmacion.popup_centered()

func mostrar_cartel_advertencia(mensaje: String):
	if dialogo_advertencia != null:
		dialogo_advertencia.queue_free()
		
	dialogo_advertencia = AcceptDialog.new()
	dialogo_advertencia.title = "Recursos insuficientes"
	dialogo_advertencia.dialog_text = mensaje
	dialogo_advertencia.ok_button_text = "Entendido"
	
	add_child(dialogo_advertencia)
	dialogo_advertencia.popup_centered()

func _on_compra_aceptada():
	var compra_exitosa = false
	
	if moneda_en_tramite == "almas":
		if PlayerData.almas >= costo_en_tramite:
			PlayerData.almas -= costo_en_tramite
			compra_exitosa = true
		else:
			# Calculamos y mostramos lo que le falta
			var faltante = costo_en_tramite - PlayerData.almas
			mostrar_cartel_advertencia("No tienes suficientes almas.\nTe faltan: " + str(faltante) + " almas.")
	else:
		# Si es mineral, buscamos su ID interno (mineral1, mineral2, etc) en el mapeo
		var id_mineral = MAPEO_MINERALES[moneda_en_tramite]
		
		if PlayerData.minerales[id_mineral] >= costo_en_tramite:
			PlayerData.minerales[id_mineral] -= costo_en_tramite
			compra_exitosa = true
		else:
			# Calculamos y mostramos lo que le falta
			var faltante = costo_en_tramite - PlayerData.minerales[id_mineral]
			mostrar_cartel_advertencia("No tienes suficientes minerales.\nTe faltan: " + str(faltante) + " de " + moneda_en_tramite.capitalize() + ".")

	if compra_exitosa:
		PlayerData.armas_compradas[arma_en_tramite] = material_en_tramite
		
		if PlayerData.arma_equipada["nombre"] == arma_en_tramite:
			PlayerData.arma_equipada["material"] = material_en_tramite
			
		PlayerData.guardar_datos()
		print("Éxito: ", arma_en_tramite, " subió a ", material_en_tramite)
		
	# Refrescamos la interfaz para actualizar los textos de los botones y la imagen
	compradas()

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
