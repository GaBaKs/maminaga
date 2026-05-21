extends Node2D

@export var max_distance := 80.0
@onready var knob = $Knob
@onready var base = $Base

var direction := Vector2.ZERO
var dragging := false
var touch_index := -1
var center := Vector2.ZERO

func _ready():
	reset_knob()

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			if is_touch_inside_base(event.position):
				touch_index = event.index
				center = get_screen_position()
				dragging = true
		elif not event.pressed and event.index == touch_index:
			touch_index = -1
			dragging = false
			direction = Vector2.ZERO
			reset_knob()
	elif event is InputEventScreenDrag and dragging and event.index == touch_index:
		var offset = event.position - center
		if offset.length() > max_distance:
			offset = offset.normalized() * max_distance
		knob.position = base.position + offset
		direction = offset / max_distance

func get_screen_position() -> Vector2:
	return base.get_screen_transform().origin

func reset_knob():
	knob.position = base.position

func is_touch_inside_base(pos):
	return pos.distance_to(get_screen_position()) <= max_distance
