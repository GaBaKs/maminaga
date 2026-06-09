extends Control

@onready var animated_sprite = $VBoxContainer/Control/AnimatedSprite2D
@onready var label_nombre = $VBoxContainer/Label
@onready var boton_accion = $VBoxContainer/Comprar

var id_skin_actual: String = ""

# Esta función la llamará el menú principal para configurar cada skin
func configurar_item(id_skin: String):
	id_skin_actual = id_skin
	label_nombre.text = id_skin.capitalize()
	
	# Cargamos el recurso SpriteFrames desde la ruta del diccionario
	var ruta_animacion = PlayerData.todas_las_skins[id_skin]
	animated_sprite.sprite_frames = load(ruta_animacion)
	animated_sprite.play("idle") # Asegurate de tener una animación llamada "idle"
	
	actualizar_boton()

func actualizar_boton():
	if PlayerData.skins_desbloqueadas.has(id_skin_actual):
		if PlayerData.skin_actual == id_skin_actual:
			boton_accion.text = "Equipado"
			boton_accion.disabled = true
		else:
			boton_accion.text = "Equipar"
			boton_accion.disabled = false
	else:
		boton_accion.text = "Comprar" # Podés agregar lógica de precios más adelante
		boton_accion.disabled = false

func _on_comprar_pressed():
	if PlayerData.skins_desbloqueadas.has(id_skin_actual):
		# Si ya la tiene, la equipa
		PlayerData.skin_actual = id_skin_actual
		PlayerData.guardar_datos()
	else:
		# Lógica de compra (ejemplo hardcodeado a 100 de oro/monedas)
		var costo = 100 
		if PlayerData.almas >= costo: # O la moneda que uses
			PlayerData.almas -= costo
			PlayerData.desbloquear_skin(id_skin_actual)
			PlayerData.guardar_datos()
			print("Skin comprada: ", id_skin_actual)
		else:
			print("No tienes suficientes almas")
	
	# Notificar al menú principal que refresque todos los botones
	get_parent().get_parent().get_parent().get_parent().actualizar_menu()
