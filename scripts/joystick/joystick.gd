extends Control

@export var max_radius := 80.0

@onready var knob = $Knob
@onready var base = $Base

var touch_index := -1
var input_vector := Vector2.ZERO
var center := Vector2.ZERO

func _ready():
	center = base.position + base.size / 2
	knob.position = center - knob.size / 2

func _input(event):

	# TOQUE INICIAL
	if event is InputEventScreenTouch:

		if event.pressed:
			touch_index = event.index
			_update_joystick(event.position)

		elif event.index == touch_index:
			touch_index = -1
			input_vector = Vector2.ZERO
			_reset_knob()

	# MOVIMIENTO DEL DEDO
	elif event is InputEventScreenDrag:

		if event.index == touch_index:
			_update_joystick(event.position)

func _update_joystick(pos):

	var offset = pos - center

	if offset.length() > max_radius:
		offset = offset.normalized() * max_radius

	knob.position = center + offset - knob.size / 2

	input_vector = offset / max_radius

func _reset_knob():
	knob.position = center - knob.size / 2
