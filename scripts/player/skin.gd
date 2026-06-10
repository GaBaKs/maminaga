extends Control

@onready var animated_sprite = $VBoxContainer/Control/AnimatedSprite2D
@onready var label_nombre = $VBoxContainer/Label
@onready var boton_accion = $VBoxContainer/Comprar

var id_skin_actual: String = ""
var dialogo_confirmacion: ConfirmationDialog

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
			boton_accion.disabled = true # Desactivamos el botón si ya está en uso
		else:
			boton_accion.text = "Equipar"
			boton_accion.disabled = false
	else:
		# Cambiamos el texto al precio simbólico en dólares
		boton_accion.text = "5 USD"
		boton_accion.disabled = false

func _on_comprar_pressed():
	if PlayerData.skins_desbloqueadas.has(id_skin_actual):
		# Si ya la tiene, pero no está equipada, la equipa
		if PlayerData.skin_actual != id_skin_actual:
			PlayerData.skin_actual = id_skin_actual
			PlayerData.guardar_datos()
			print("Skin equipada: ", id_skin_actual)
			get_parent().get_parent().get_parent().actualizar_menu()
	else:
		# Lógica de compra simbólica: disparamos el cartel de confirmación
		mostrar_cartel_confirmacion()

func mostrar_cartel_confirmacion():
	# Si ya existía un cartel de antes, lo borramos para no acumular basura
	if dialogo_confirmacion != null:
		dialogo_confirmacion.queue_free()
		
	# Creamos el cartel nativo de Godot por código
	dialogo_confirmacion = ConfirmationDialog.new()
	dialogo_confirmacion.title = "Confirmar Compra"
	dialogo_confirmacion.dialog_text = "¿Esta seguro que quiere hacer esta compra?"
	dialogo_confirmacion.ok_button_text = "Aceptar"
	dialogo_confirmacion.cancel_button_text = "Cancelar"
	
	# Conectamos el botón de Aceptar a nuestra función de compra
	dialogo_confirmacion.confirmed.connect(_on_compra_aceptada)
	# (El botón de cancelar ya cierra la ventana automáticamente por defecto en Godot)
	
	# Lo agregamos a la escena y lo mostramos en el centro de la pantalla
	add_child(dialogo_confirmacion)
	dialogo_confirmacion.popup_centered()

func _on_compra_aceptada():
	# Desbloqueamos la skin en la persistencia
	PlayerData.desbloquear_skin(id_skin_actual)
	
	# Se la equipamos automáticamente por comodidad
	PlayerData.skin_actual = id_skin_actual 
	PlayerData.guardar_datos()
	
	print("Skin comprada por 5 USD (simbólico) y equipada: ", id_skin_actual)
	
	# Notificar al menú principal que refresque todos los botones
	get_parent().get_parent().get_parent().actualizar_menu()
