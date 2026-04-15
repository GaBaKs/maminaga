extends CharacterBody2D

@export var speed := 100
@export var change_direction_time := 2.0

var direction := Vector2.ZERO
var timer := 0.0

func _ready():
	randomize()
	pick_new_direction()

func _physics_process(delta):
	timer -= delta

	# Si pasa el tiempo → cambia dirección
	if timer <= 0:
		pick_new_direction()

	velocity = direction * speed
	move_and_slide()

	# Si choca con una pared → cambia dirección inmediatamente
	if is_on_wall():
		pick_new_direction()

func pick_new_direction():
	if randf() < 0.3:
		direction = Vector2.ZERO
	else:
		direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized()

	timer = change_direction_time
