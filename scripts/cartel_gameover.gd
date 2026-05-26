extends CanvasLayer
@onready var titulo = $Panel/Label  # Quita el "Panel/" si no tienes un nodo Panel
@onready var boton_revivir = $Panel/Label/BotonRevivir # Asegúrate que el nombre sea idéntico al del nodo
@onready var boton_reintentar = $Panel/Label/BotonReintentar
func _ready():
	Global.jugador_murio.connect(_on_jugador_murio)
	Global.cartel_interfaz = self 
	visible = false

func _on_boton_revivir_pressed():
	visible = false
	Global.revivir_jugador()

func _on_boton_menu_pressed():
	get_tree().paused = false
	Global.finalizar_partida(false) # Se pierden los minerales de la partida 
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")

func _on_jugador_murio():
	visible=true

func _on_jugador_revivio():
	visible=false
