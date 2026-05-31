extends AudioStreamPlayer


func _ready() -> void:
	play(15)

func _process(delta: float) -> void:
	if get_playback_position() >= 44:
		seek(15)
