extends Enemigo_abstract

func _ready():
	super() 
	
	vida_enemigo = 6.0 # Mucha más vida
	speed -= 20 # Es más pesado y lento
