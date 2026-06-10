extends AudioStreamPlayer


func _ready() -> void:
	play(0)

func _process(delta: float) -> void:
	if get_playback_position() >= 15:
		seek(6)
