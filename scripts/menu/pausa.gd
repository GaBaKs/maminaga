extends Button  # o el nodo que uses

@onready var menu_pausa = $"../Pausa"

func _ready():
	pressed.connect(_on_pausa_pressed)

func _on_pausa_pressed():
	get_tree().paused = true
	menu_pausa.visible = true
