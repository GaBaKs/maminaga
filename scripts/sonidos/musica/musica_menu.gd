extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(17)

func _process(delta: float) -> void:
	if get_playback_position() >= 56:
		seek(18.6)
