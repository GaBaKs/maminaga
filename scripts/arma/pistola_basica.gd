# pistola_basica.gd
extends ArmaAbstract

func atacar(objetivo: Node2D) -> void:
	# Ejecuta el freno de ataques por segundo del script padre
	super.atacar(objetivo) 
	
	print("Disparando infinitamente a: ", objetivo.name, " | Daño: ", danio)
	
	# Conexión directa con su función actual del enemigo para aplicar knockback
	if objetivo.has_method("recibir_danio_enemigo"):
		var direccion_golpe = (objetivo.global_position - global_position).normalized()
		objetivo.recibir_danio_enemigo(danio, direccion_golpe)
