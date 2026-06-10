extends Control

@onready var vbox_container = $VBoxContainer
@onready var description_button = $ButtonDescription
@onready var contenido_description = $ContenidoDescription
@onready var cerrar_button = $ContenidoDescription/Cerrar
@onready var contenedorDesc = $Description

func _ready():
	contenido_description.hide()
	description_button.pressed.connect(_on_description_pressed)
	cerrar_button.pressed.connect(_on_cerrar_pressed)

func _on_description_pressed():
	vbox_container.hide()
	contenedorDesc.hide()
	description_button.hide()
	contenido_description.show()

func _on_cerrar_pressed():
	contenido_description.hide()
	contenedorDesc.show()
	vbox_container.show()
	description_button.show()

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/seleccion_mapa.tscn")
	
func _on_equipo_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/equipo.tscn")
	
#llamar a equipar_arma (q esta en global)
func _on_estadisticas_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/estadisticas.tscn")
	
func _on_aspectos_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/aspectos.tscn")

func _on_button_description_pressed() -> void:
	pass # Replace with function body.
