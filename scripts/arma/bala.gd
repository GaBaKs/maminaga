extends Area2D

var velocidad := 500
var danio_bala
var direccion := Vector2.ZERO:
	set(value):
		direccion = value
		if value != Vector2.ZERO:
			rotation = value.angle()



func _process(delta):
	position += direccion * velocidad * delta

func _on_body_entered(body):
	if body.has_method("recibir_danio_enemigo"):
		body.recibir_danio_enemigo(danio_bala, direccion)
		queue_free()
