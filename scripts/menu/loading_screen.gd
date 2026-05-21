extends Control

@onready var progress_bar = $VBoxContainer/ProgressBar
var scene_path : String
var progress = []

func _ready():
	# 1. Obtenemos la ruta que guardamos en el script Global
	scene_path = Global.nivel_a_cargar

	# 2. Verificamos que la ruta no esté vacía
	if scene_path == "":
		print("Error: No hay ruta de escena definida en Global")
		return

	# 3. Iniciamos la petición de carga en segundo plano
	var error = ResourceLoader.load_threaded_request(scene_path)
	if error != OK:
		print("Error al iniciar la carga asíncrona")

func _process(_delta):
	# 4. Consultamos el estado de la carga
	var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# Actualizamos la barra (multiplicamos por 100 porque progress[0] va de 0 a 1)
			progress_bar.value = progress[0] * 100
			
		ResourceLoader.THREAD_LOAD_LOADED:
			# ¡Éxito! Obtenemos la escena empaquetada
			var new_scene = ResourceLoader.load_threaded_get(scene_path)
			
			# Esperamos un momento pequeño para que el jugador vea el 100% (opcional)
			await get_tree().create_timer(0.5).timeout
			
			# Cambiamos a la nueva escena
			get_tree().change_scene_to_packed(new_scene)
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error: La carga falló")
