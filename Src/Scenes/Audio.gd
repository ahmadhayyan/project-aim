extends Node


var cur_sound : String = "Tick"


func play(sound, duration = 0, randomize_pitch = true) -> void:
	if has_node(sound):
		cur_sound = sound
		
		if randomize_pitch:
			get_node(sound).pitch_scale = randomize_pitch()
		get_node(sound).play()
		
		if duration > 0:
			$Timer.start(duration)

func stop() -> void:
	get_node(cur_sound).stop()

func randomize_pitch() -> float:
	randomize()
	var pitch_scale : float = rand_range(0.8, 1.2)
	return pitch_scale
