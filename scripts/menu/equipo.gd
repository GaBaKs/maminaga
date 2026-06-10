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
const COSTOS_MEJORA = {
	"madera":   {"mineral": "mineral1", "costo": 1}, # Costo inicial para obtener el arma base
	"amatista": {"mineral": "mineral1", "costo": 5},
	"ruby":     {"mineral": "mineral2", "costo": 5},
	"agatha":   {"mineral": "mineral3", "costo": 10}
}

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

	# --- LÓGICA PARA ACTUALIZAR LA IMAGEN ---
	# Construimos el nombre del archivo exacto (ej: "espada-madera.png")
	var nombre_archivo = id_arma + "-" + material_actual + ".png"
	var ruta_completa = RUTA_SPRITES + nombre_archivo
	
	# Usamos ResourceLoader para evitar que el juego crashee si te falta alguna imagen
	if ResourceLoader.exists(ruta_completa):
		nodo_img.texture = load(ruta_completa)
	else:
		print("ATENCIÓN: No se encontró la imagen en la ruta: ", ruta_completa)

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
		
	var datos_costo = COSTOS_MEJORA[material_objetivo]
	var mineral_requerido = datos_costo["mineral"]
	var costo = datos_costo["costo"]
	
	if PlayerData.minerales[mineral_requerido] >= costo:
		PlayerData.minerales[mineral_requerido] -= costo
		PlayerData.armas_compradas[id_arma] = material_objetivo
		
		if PlayerData.arma_equipada["nombre"] == id_arma:
			PlayerData.arma_equipada["material"] = material_objetivo
			
		PlayerData.guardar_datos()
		print("Éxito: ", id_arma, " subió a ", material_objetivo)
	else:
		print("Faltan recursos. Necesitas ", costo, " de ", mineral_requerido)
		
	# Refrescamos la interfaz para actualizar los textos de los botones y la imagen
	compradas()

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
