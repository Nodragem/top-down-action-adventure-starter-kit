class_name CrabtopusAnimator
extends AnimationTree

enum Direction {FORWARD = 1, BACKWARD = -1}

func _ready():
	self["parameters/eye_priority/blend_amount"] = 0
	self["parameters/play_shielding/scale"] = -1

func move_to_idling() -> void:
	self["parameters/state/transition_request"] = "Idling"

func move_to_dead() -> void:
	self["parameters/state/transition_request"] = "Dead"

func play_shielding(direction:Direction) -> void:
	self["parameters/eye_priority/blend_amount"] = 1
	self["parameters/play_shielding/scale"] = direction
	if direction == Direction.FORWARD:
		var tween = create_tween()
		tween.tween_callback(play_shielding.bind(Direction.BACKWARD)).set_delay(1)
	
func play_blink(is_requested: bool) -> void:
	if is_requested:
		self["parameters/eye_priority/blend_amount"] = 0
		self["parameters/play_shielding/scale"] = -1
		self["parameters/on_blink/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		self["parameters/on_blink/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
		
