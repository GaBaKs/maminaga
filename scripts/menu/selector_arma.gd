extends Control
@export var arma_laser: PackedScene
@export var arma_canon: PackedScene
@export var arma_espada: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boton_laser_pressed():
	Global.arma_elegida = arma_laser
	get_tree().change_scene_to_file("res://mapa.tscn")

func _on_boton_canon_pressed():
	Global.arma_elegida = arma_canon
	get_tree().change_scene_to_file("res://mapa.tscn")

func _on_boton_espada_pressed():
	Global.arma_elegida = arma_espada
	get_tree().change_scene_to_file("res://mapa.tscn")
