extends Area2D


var direction:= Vector2.ZERO
var speed: float = 200.0
var danio:= 10


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(cuerpo):
	if cuerpo.has_method("recibir_danio"):
		cuerpo.recibir_danio(danio)
		queue_free()
	elif not cuerpo.is_in_group("enemigo"):
		queue_free()  # chocó con una pared
