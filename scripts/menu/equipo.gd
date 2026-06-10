extends Control

# Asegúrate de arrastrar tus botones aquí desde el panel de Nodos
@onready var btn_espada = $boton_espada
@onready var btn_arco = $boton_arco 
@onready var btn_hacha = $boton_hacha

@onready var boton_equipar_espada = $boton_equipar_espada
@onready var boton_equipar_arco = $boton_equipar_arco 
@onready var boton_equipar_hacha = $boton_equipar_hacha

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
	# Evaluamos cada botón pasando el nodo y el ID del arma
	configurar_botones(btn_espada, boton_equipar_espada, "espada")
	configurar_botones(btn_arco, boton_equipar_arco, "arco")
	configurar_botones(btn_hacha, boton_equipar_hacha, "hacha")

func configurar_botones(btn_principal: Button, btn_equip: Button, id_arma: String):
	if PlayerData.armas_compradas.has(id_arma):
		var material_actual = PlayerData.armas_compradas[id_arma]
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

func _on_boton_espada_pressed(): procesar_compra_mejora("espada")
func _on_boton_arco_pressed(): procesar_compra_mejora("arco") 
func _on_boton_hacha_pressed(): procesar_compra_mejora("hacha")

func _on_boton_equip_pressed(id_arma: String):
	# Si ya la tiene, la equipa
	PlayerData.equipar_arma(id_arma)
	# Refrescamos la interfaz para que los textos de los botones cambien
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
		
	# Refrescamos la interfaz para que los textos de los botones cambien
	compradas()

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
