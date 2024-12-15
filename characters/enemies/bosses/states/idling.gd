extends State

@onready var _blink_timer:Timer = $BlinkTimer
var blink_interval:float

func _ready() -> void:
	await super._ready()
	blink_interval = _blink_timer.wait_time
	_blink_timer.timeout.connect(_state_machine.animator.play_blink.bind(true))
	_blink_timer.timeout.connect(restart_timer)
	_state_machine.shield_area.body_entered.connect(_on_shield_area_entered)


func restart_timer() -> void:
	_blink_timer.start(max(randfn(blink_interval, 2.0), 0))


func _on_shield_area_entered(body:Node3D):
	if body.is_in_group("bullet"):
		_state_machine.animator.play_shielding(1)


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func enter(msg: = {}) -> void:
	_blink_timer.start()
	_state_machine.animator.move_to_idling()
	_parent.enter(msg)


func exit() -> void:
	_state_machine.animator.play_blink(false)
	_blink_timer.stop()
	_parent.exit()
