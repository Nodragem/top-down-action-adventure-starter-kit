class_name BasePlayerPlatformer3D
extends KinematicBody

export var move_speed := 6.0
export var acceleration := 6.0
export var jump_initial_impulse := 12.0
export var jump_additional_force := 4.5
export var rotation_speed := 12.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _velocity: Vector3
var _snap := Vector3.DOWN * snap_length
var _gravity: float = -30.0

onready var _camera_controller := $ThirdPersonCamera
onready var _model := $IcySkin

onready var _start_position := global_transform.origin


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_base_movement(delta)

func apply_base_movement(delta: float) -> void:
	_move_direction = _get_player_input()

	# if _move_direction is 0, we will get weird orientation!
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
	# to use _last_strong_direction also make sure we have a default value to start with
	_orient_character_to_direction(_last_strong_direction, delta)

	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity := _velocity.y
	_velocity.y = 0.0
	_velocity = _velocity.linear_interpolate(_move_direction * move_speed, acceleration * delta)
	_velocity.y = y_velocity

	if jumping_detected():
		_velocity.y = jump_initial_impulse
		_snap = Vector3.ZERO
#		_model.jump()
	elif landing_detected():
		_snap = Vector3.DOWN * snap_length
		_model.land()

	_velocity = move_and_slide_with_snap(
		_velocity, _snap, Vector3.UP, do_stop_on_slope, 4, deg2rad(45), has_infinite_inertia
	)

	if is_on_floor():
		_velocity.y = 0.0
	else:
		_velocity.y += _gravity * delta
	_model.velocity = _velocity


func _get_player_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var input_forward_back := (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	var raw_input := Vector2(input_left_right, input_forward_back)

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	# More optimised than to normalise?
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = _camera_controller.global_transform.basis.xform(input)
	return input

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction)\
	.orthonormalized()
	
	## in what sense is it different from transform.look_at + interpolate_with?
	_model.transform.basis = _model.transform.basis\
	.orthonormalized()\
	.slerp(rotation_basis, delta * rotation_speed)\
	.scaled(_model.scale)
	
	# can also try this:
#	_model.transform.basis = _model.transform.basis
#	.get_rotation_quat().slerp(
#		rotation_basis, delta * rotation_speed
#	)

func jumping_detected() -> bool:
	return Input.is_action_just_pressed("jump") and is_on_floor()


func landing_detected() -> bool:
	return _snap == Vector3.ZERO and is_on_floor()

func reset_position() -> void:
	transform.origin = _start_position

