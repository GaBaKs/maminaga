extends Control

@onready var hbox_container = $ScrollContainer/HBoxContainer

# Arrastrá acá tu escena SkinItem.tscn desde el sistema de archivos al Inspector
@export var skin_item_escena: PackedScene

func _ready():
	cargar_skins_en_menu()

func cargar_skins_en_menu():
	# Limpiamos el contenedor por si acaso
	for hijo in hbox_container.get_children():
		hijo.queue_free()
		
	# Recorremos el diccionario de PlayerData e instanciamos cada skin
	for id_skin in PlayerData.todas_las_skins:
		var nuevo_item = skin_item_escena.instantiate()
		hbox_container.add_child(nuevo_item)
		nuevo_item.configurar_item(id_skin)

# Refresca los textos de todos los ítems cuando equipás o comprás algo
func actualizar_menu():
	for item in hbox_container.get_children():
		if item.has_method("actualizar_boton"):
			item.actualizar_boton()
