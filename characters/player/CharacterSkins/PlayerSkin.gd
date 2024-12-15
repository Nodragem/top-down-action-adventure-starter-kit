class_name PlayerSkin
extends Node3D

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var shoot_anchor: Marker3D = %ShootAnchor
@onready var muzzle_vfx: MeshInstance3D = %MuzzleVFX
@export var rotation_speed := 12.0

var _last_strong_direction := Vector3.FORWARD
var muzzle_tween:Tween

func _ready() -> void:
	anim_tree.active = true
	muzzle_vfx.visible = false
	muzzle_vfx.scale = Vector3()
	reset_animations()

func reset_animations():
	anim_tree["parameters/blend_running/blend_amount"] = 0
	anim_tree["parameters/blend_straffing/blend_amount"] = 0
	anim_tree["parameters/blend_aim/blend_amount"] = 0
	anim_tree["parameters/blend_weapon/blend_amount"] = 1
	anim_tree["parameters/draw_weapon/scale"] = -1
	anim_tree["parameters/state/transition_request"] = "Running"


func update_move_animation(velocity_ratio, delta) -> void:
	anim_tree["parameters/blend_running/blend_amount"] = velocity_ratio
	anim_tree["parameters/blend_straffing/blend_amount"] = velocity_ratio
	

func move_to_falling() -> void:
	anim_tree["parameters/state/transition_request"] = "Falling"


func move_to_jumping() -> void:
	anim_tree["parameters/state/transition_request"] = "Jumping"


func move_to_running() -> void:
	anim_tree["parameters/state/transition_request"] = "Running"


func move_to_dead() -> void:
	anim_tree["parameters/state/transition_request"] = "Dead"


func play_idle_break(is_requested: bool) -> void:
	if is_requested:
		anim_tree["parameters/on_idle_break/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		anim_tree["parameters/on_idle_break/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT


func play_on_hit(is_requested:bool):
	if is_requested:
		anim_tree["parameters/on_hit/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		anim_tree["parameters/on_hit/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT


func play_aiming(value: bool) -> void:
	if value:
		anim_tree["parameters/blend_aim/blend_amount"] = 1
		anim_tree["parameters/draw_weapon/scale"] = 1
	else:
		anim_tree["parameters/blend_aim/blend_amount"] = 0
		anim_tree["parameters/draw_weapon/scale"] = -1


func play_shooting(is_requested: bool) -> void:
	muzzle_vfx.visible = true
	print("randf: ",  randf_range(-2*PI,2*PI))
	#muzzle_vfx.rotate(Vector3(1,0,0), randf_range(-2*PI,2*PI))
	muzzle_vfx.rotation.x = randf_range(-2*PI,2*PI)
	
	muzzle_tween = self.create_tween()
	var scale_r = randf_range(0.9, 1.2)
	(muzzle_tween.tween_property(muzzle_vfx, "scale", Vector3(scale_r,scale_r*1.5,scale_r), 0.06)
		.set_trans(Tween.TRANS_QUAD)
		.set_ease(Tween.EASE_OUT))
	(muzzle_tween.tween_property(muzzle_vfx, "scale", Vector3(), 0.1)
		.set_trans(Tween.TRANS_QUAD)
		.set_ease(Tween.EASE_IN))
	muzzle_tween.tween_callback(func(): muzzle_vfx.visible = false)
	if is_requested:
		anim_tree["parameters/on_shooting/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		anim_tree["parameters/on_shooting/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
	

func orient_model_to_direction(direction: Vector3, delta: float) -> void:
	
	if direction.length() > 0.2:
		_last_strong_direction = direction

	# Remember that Y is the Up Axis
	# Hence, direction.x and direction.z gives us the direction on the floor 
	# Also, LERP is used cumulatively here
	global_rotation.y = lerp_angle(
		global_rotation.y, 
		Vector2(_last_strong_direction.z, _last_strong_direction.x).angle(), 
		delta*rotation_speed
	)
	
