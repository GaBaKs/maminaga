extends CanvasLayer

@onready var vida: Label = $Control/vida
@onready var daño: Label = $"Control/daño"
@onready var vel_ataque: Label = $Control/vel_ataque
@onready var regen_vida: Label = $Control/regen_vida
@onready var armadura: Label = $Control/armadura

@onready var btn_vida: Button = $Panel/HBoxContainer/btn_vida
@onready var btn_daño: Button = $Panel/HBoxContainer/btn_daño
@onready var btn_vel_ataque: Button = $Panel/HBoxContainer/btn_vel_ataque
@onready var btn_regen_vida: Button = $Panel/HBoxContainer/btn_regen_vida
@onready var btn_armadura: Button = $Panel/HBoxContainer/btn_armadura


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_stats() -> void:
		vida.text = str(PlayerData.vida)
		daño.text = str(PlayerData.danio)
		vel_ataque.text = str(PlayerData.velocidad_ataque)
		regen_vida.text = str(PlayerData.regen_vida)
		armadura.text = str(PlayerData.armadura)
		PlayerData.guardar_datos()
