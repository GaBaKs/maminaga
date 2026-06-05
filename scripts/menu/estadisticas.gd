extends CanvasLayer

@onready var vida: Label = $Control/vida
@onready var daño: Label = $"Control/daño"
@onready var vel_ataque: Label = $Control/vel_ataque
@onready var regen_vida: Label = $Control/regen_vida
@onready var armadura: Label = $Control/armadura
@onready var puntos: Label = $Control/puntos
@onready var btn_vida: Button = $Control/btn_vida
@onready var btn_daño: Button = $"Control/btn_daño"
@onready var btn_vel_ataque: Button = $Control/btn_velataque
@onready var btn_regen_vida: Button = $Control/btn_regenvida
@onready var btn_armadura: Button = $Control/btn_armadura


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_vida.pressed.connect(_on_btn_vida_pressed)
	btn_daño.pressed.connect(_on_btn_daño_pressed)
	btn_vel_ataque.pressed.connect(_on_btn_vel_ataque_pressed)
	btn_regen_vida.pressed.connect(_on_btn_regen_vida_pressed)
	btn_armadura.pressed.connect(_on_btn_armadura_pressed)
	update_stats()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_stats() -> void:
		vida.text = str(PlayerData.vida)
		daño.text = str(PlayerData.danio)
		puntos.text = str(PlayerData.puntos_habilidad)
		vel_ataque.text = str(PlayerData.velocidad_ataque)
		regen_vida.text = str(PlayerData.regen_vida)
		armadura.text = str(PlayerData.armadura)

func _on_btn_vida_pressed() -> void:
	if PlayerData.puntos_habilidad > 0:
		PlayerData.vida += 10
		PlayerData.puntos_habilidad -= 1
		update_stats()

func _on_btn_daño_pressed() -> void:
	if PlayerData.puntos_habilidad > 0:
		PlayerData.danio += 10
		PlayerData.puntos_habilidad -= 1
		update_stats()

func _on_btn_vel_ataque_pressed() -> void:
	if PlayerData.puntos_habilidad > 0:
		PlayerData.velocidad_ataque += 0.05
		PlayerData.puntos_habilidad -= 1
		update_stats()

func _on_btn_regen_vida_pressed() -> void:
	if PlayerData.puntos_habilidad > 0:
		PlayerData.regen_vida += 1
		PlayerData.puntos_habilidad -= 1
		update_stats()

func _on_btn_armadura_pressed() -> void:
	if PlayerData.puntos_habilidad > 0:
		PlayerData.armadura += 1
		PlayerData.puntos_habilidad -= 1
		update_stats()
		
func _on_volver_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/menu.tscn")
	PlayerData.guardar_datos()
	pass
