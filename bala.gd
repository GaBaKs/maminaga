extends Area2D

var velocidad := 500
var direccion := Vector2.ZERO # Podés setearla al instanciarla

func _process(delta):
	# Si la dirección no es cero, se mueve
	if direccion != Vector2.ZERO:
		position += direccion * velocidad * delta

func _on_body_entered(body):
	print("Choqué con: ", body.name)
	if body.has_method("recibir_danio_enemigo"):
		# Pasamos el daño Y la dirección actual de la bala
		body.recibir_danio_enemigo(2, direccion) 
		queue_free()
