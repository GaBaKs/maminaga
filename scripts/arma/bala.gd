extends Area2D

var velocidad := 500
var direccion := Vector2.ZERO
var danio_bala

func _process(delta):
	if direccion != Vector2.ZERO:
		position += direccion * velocidad * delta

func _on_body_entered(body):
	if body.has_method("recibir_danio_enemigo"):
		body.recibir_danio_enemigo(danio_bala, direccion) 
		queue_free()
