extends CanvasLayer

@onready var control = $Control
@onready var boton_continuar = $Control/Continuar
@onready var boton_volver = $Control/Vovler

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # asegura que funcione en pausa
	visible = false
	boton_continuar.pressed.connect(_on_continuar_pressed)
	boton_volver.pressed.connect(_on_volver_pressed)

func abrir_pausa():
	get_tree().paused = true
	visible = true

func _on_continuar_pressed():
	get_tree().paused = false
	visible = false

func _on_volver_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")  # ajustá la ruta

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_on_continuar_pressed()
		else:
			abrir_pausa()
