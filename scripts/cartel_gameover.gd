extends CanvasLayer
@onready var titulo = $Panel/Label 
@onready var boton_revivir = $Panel/Label/BotonRevivir 
@onready var boton_menu = $Panel/Label/BotonMenu

func _ready():
	Global.jugador_murio.connect(_on_jugador_murio)
	Global.cartel_interfaz = self 
	visible = false

func _on_boton_revivir_pressed():
	visible = false
	Global.emit_signal("jugador_revivio")

func _on_boton_menu_pressed():
	if Global.referencia_jugador != null:
		Global.referencia_jugador.resetear_recursos_temporales()
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")

func _on_jugador_murio(yamurio: bool):
	print("murio")
	if yamurio:
		print("ya termina el juego y va al menu")
	visible=true

	
